import React, {PropTypes} from 'react/addons';
import ComponentIcon from '../../../../react/common/ComponentIcon';
import ComponentName from '../../../../react/common/ComponentName';
import SearchRow from '../../../../react/common/SearchRow';
import ComponentsStore from '../../stores/ComponentsStore';
import {ListGroup, ListGroupItem} from 'react-bootstrap';

import lodash from 'lodash';
import fuzzy from 'fuzzy';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import './componentsOverview.less';

// TODO udělat z toho nějakej validační objekt, kterej vrátí warningy a errory, bude se používat i při validaci vstupů

var ComponentCheck = React.createClass({
  propTypes: {
    component: PropTypes.object.isRequired
  },

  render() {
    return (
      <ListGroupItem header={this.header()} bsStyle={this.itemClass()}>
        {this.renderErrors()}
        {this.renderWarnings()}
      </ListGroupItem>
    );
  },

  header() {
    return (
      <div>
        <ComponentIcon component={this.props.component}/>
        <ComponentName component={this.props.component}/>
        &nbsp;
        <small>({this.props.component.get('id')})</small>
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
      return 'warning';
    }
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

  getErrors() {
    var errors = [];
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
    var errors = [];
    if (!this.props.component.get('longDescription')) {
      errors.push('Missing long description');
    }
    if (this.props.component.get('flags').contains('excludeFromNewList')) {
      errors.push('Hidden in new list');
    }

    return errors;
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
        <ListGroup>
          {this.components()}
        </ListGroup>
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
        return (<ComponentCheck component={component}/>);
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
