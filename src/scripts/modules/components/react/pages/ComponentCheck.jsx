import React, {PropTypes} from 'react/addons';
import ComponentIcon from '../../../../react/common/ComponentIcon';
import ComponentName from '../../../../react/common/ComponentName';
import ComponentDetailLink from '../../../../react/common/ComponentDetailLink';
import {Panel} from 'react-bootstrap';

// TODO udělat z toho nějakej validační objekt, kterej vrátí warningy a errory, bude se používat i při validaci vstupů

export default React.createClass({
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
    var result = [];
    var errors = this.getErrors();
    if (errors.length > 0) {
      for (var i = 0; i < errors.length; i++) {
        var error = errors[i];
        result.push((
          <p>
            <i className="fa fa-exclamation fa-fw"></i> {error}
          </p>
        ));
      }
    }
    return result;
  },

  renderWarnings() {
    var result = [];
    var warnings = this.getWarnings();
    if (warnings.length > 0) {
      for (var i = 0; i < warnings.length; i++) {
        var warning = warnings[i];
        result.push((
          <p>
            <i className="fa fa-question fa-fw"></i> {warning}
          </p>
        ));
      }
    }
    return result;
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

    if (this.is3rdPartyComponent() && !this.props.component.getIn(['data', 'vendor', 'contact'])) {
      errors.push('Missing vendor contact information');
    }

    if (this.is3rdPartyComponent() && !this.props.component.getIn(['data', 'vendor', 'licenseUrl'])) {
      errors.push('Missing license url');
    }

    if (!this.props.component.getIn(['documentationUrl']) &&
      (
        this.props.component.get('flags').contains('genericUI') ||
        this.props.component.get('flags').contains('genericDockerUI') ||
        this.props.component.get('flags').contains('genericTemplatesUI')
      )
    )  {
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
