import React, {PropTypes} from 'react/addons';
import ComponentIcon from '../../../../react/common/ComponentIcon';
import ComponentName from '../../../../react/common/ComponentName';
import ComponentDetailLink from '../../../../react/common/ComponentDetailLink';
import SearchRow from '../../../../react/common/SearchRow';
import ComponentsStore from '../../stores/ComponentsStore';
import {Panel} from 'react-bootstrap';

import lodash from 'lodash';
import fuzzy from 'fuzzy';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import './componentsOverview.less';

// TODO udělat z toho nějakej validační objekt, kterej vrátí warningy a errory, bude se používat i při validaci vstupů

var ComponentCheck = React.createClass({
  propTypes: {
    component: PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      expanded: false
    };
  },

  render() {
    return (
      <Panel header={this.header()} bsStyle={this.itemClass()} className="componentsOverview">
        {this.renderErrors()}
        {this.renderWarnings()}
        {this.renderDefinition()}
      </Panel>
    );
  },

  toggleExpand() {
    this.setState({
      expanded: !this.state.expanded
    });
  },

  renderDefinition() {
    if (!this.state.expanded) {
      return (
        <p><a onClick={this.toggleExpand}>Expand &raquo;</a></p>
      );
    } else {
      return (
        <span>
          <p><a onClick={this.toggleExpand}>&laquo; Collapse</a></p>
          <pre>
            {JSON.stringify(this.props.component.toJSON(), null, 2)}
          </pre>
        </span>
      );
    }
  },

  header() {
    return (
      <div>
        <ComponentDetailLink
          componentId={this.props.component.get('id')}
          type={this.props.component.get('type')}
          >
          <ComponentIcon component={this.props.component}/>
          <ComponentName component={this.props.component}/>
          &nbsp;
          <small>({this.props.component.get('id')})</small>
        </ComponentDetailLink>
      </div>
    );
  },

  renderErrors() {
    return lodash.map(this.getErrors(), function(error) {
      return (
        <p className="text-error">
          <i className="fa fa-exclamation fa-fw"></i> {error}
        </p>
      );
    });
  },

  renderWarnings() {
    return lodash.map(this.getWarnings(), function(error) {
      return (
        <p className="text-warning">
          <i className="fa fa-question fa-fw"></i> {error}
        </p>
      );
    });
  },


  itemClass() {
    if (this.getErrors().length > 0) {
      return 'danger';
    }
    if (this.getWarnings().length > 0) {
      return 'danger';
    }
    return 'success';
  },

  isDockerComponent() {
    return this.props.component.getIn(['uri'], '').indexOf('/docker/') >= 0;
  },

  is3rdPartyComponent() {
    return this.isDockerComponent() && this.props.component.getIn(['data', 'definition', 'uri'], '').indexOf('keboola/') === -1;
  },

  has3rdPartyFlag() {
    return this.props.component.get('flags').contains('3rdParty');
  },

  getErrors(force) {
    var errors = [];
    if (this.props.component.get('flags').contains('excludeFromNewList') && !force) {
      return [];
    }
    if (!this.props.component.get('description')) {
      errors.push('Missing description');
    }

    if (this.is3rdPartyComponent() && !this.has3rdPartyFlag()) {
      errors.push('Missing 3rdParty flag');
    }

    if (!this.props.component.get('ico32')) {
      errors.push('Missing 32px icon');
    }

    if (!this.props.component.get('ico64')) {
      errors.push('Missing 64px icon');
    }

    if (this.is3rdPartyComponent() && !this.props.component.getIn(['vendor', 'contact'])) {
      errors.push('Missing vendor contact information');
    }

    if (this.is3rdPartyComponent() && !this.props.component.getIn(['vendor', 'licenseUrl'])) {
      errors.push('Missing license url');
    }

    if (!this.props.component.getIn(['documentationUrl']) &&
      (this.props.component.get('flags').contains('genericUI') || this.props.component.get('flags').contains('genericDockerUI'))) {
      errors.push('Missing documentation url');
    }

    return errors;
  },

  getWarnings() {
    var warnings = [];
    /*
     if (!this.props.component.get('longDescription')) {
     warnings.push('Missing long description');
     }
     */
    if (this.props.component.get('flags').contains('excludeFromNewList')) {
      warnings.push('Hidden in new list');
      var errors = this.getErrors(true);
      for (var i = 0; i < errors.length; i++) {
        warnings.push(errors[i]);
      }
    }
    return warnings;
  }
});

export default React.createClass({
  mixins: [createStoreMixin(ComponentsStore)],

  getStateFromStores() {
    return {
      components: ComponentsStore.getAll()
    };
  },

  getInitialState() {
    return {
      filter: ''
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <SearchRow
          onChange={this.handleFilterChange}
          query={this.state.filter} />
        {this.components()}
      </div>
    );
  },

  components() {
    return this.filteredComponents()
      .toIndexedSeq()
      .sortBy(function(component) {
        return component.get('id').toLowerCase();
      })
      .map(function(component) {
        return (
          <ComponentCheck
            component={component}
            key={component.get('id')}
            />
        );
      }
    ).toArray();
  },

  handleFilterChange(value) {
    this.setState({filter: value});
  },

  filteredComponents() {
    var filter = this.state.filter;
    return this.state.components
      .filter(function(value) {
        return fuzzy.match(filter, value.get('name').toString()) || fuzzy.match(filter, value.get('id').toString());
      }
    );
  }

});
