import React, {PropTypes} from 'react';
import Immutable from 'immutable';
import {Input} from 'react-bootstrap';
import Markdown from 'react-markdown';
import deepEqual from 'deep-equal';

/* global require */
require('./configuration-json.less');

export default React.createClass({

  propTypes: {
    value: PropTypes.object.isRequired,
    templates: PropTypes.object.isRequired,
    readOnly: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired
  },

  render() {
    return this.jobsSelector();
  },

  jobsSelector() {
    return (
      <div>
        <Input
          type="select"
          ref="config"
          onChange={this.handleSelectorChange}
          disabled={this.props.readOnly}>
          <option value={Immutable.List().hashCode()} disabled>Select template...</option>
          {this.templatesSelectorOptions(this.props.value)}
        </Input>
        {this.templateDescription()}
      </div>
    );
  },

  templateDescription() {
    if (this.getTemplate(this.props.value)) {
      return (
        <Markdown
          source={this.getTemplate(this.props.value).get('description')}
          />
      );
    }
    return null;
  },

  getTemplate(value) {
    return this.props.templates.filter(
      function(template) {
        return deepEqual(template.get('jobs').toJS(), value.get('jobs').toJS()) &&
          deepEqual(template.get('mappings').toJS(), value.get('mappings').toJS());
      }
    ).first();
  },

  templatesSelectorOptions(value) {
    return this.props.templates.map(
      function(option) {
        var selected = deepEqual(option.get('jobs').toJS(), value.get('jobs').toJS()) &&
          deepEqual(option.get('mappings').toJS(), value.get('mappings').toJS());
        return (
          <option
            value={JSON.stringify(option.toJS())}
            key={option.hashCode()}
            selected={selected}
          >
            {option.get('name')}
          </option>
        );
      }
    );
  },

  handleSelectorChange() {
    var selectedTemplate = this.getTemplate(Immutable.fromJS(JSON.parse(this.refs.config.getValue())));
    if (selectedTemplate) {
      this.props.onChange(selectedTemplate);
    } else {
      this.props.onChange(Immutable.Map());
    }
  }

});
