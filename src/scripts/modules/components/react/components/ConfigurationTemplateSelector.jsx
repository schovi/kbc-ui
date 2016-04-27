import React, {PropTypes} from 'react';
import Immutable from 'immutable';
import {Input} from 'react-bootstrap';
import Markdown from 'react-markdown';
import getTemplatedConfigHashCode from '../../utils/getTemplatedConfigHashCode';

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
          value={getTemplatedConfigHashCode(this.props.value)}
          ref="config"
          onChange={this.handleSelectorChange}
          disabled={this.props.readOnly}>
          <option value={Immutable.List().hashCode()} disabled>Select template...</option>
          {this.templatesSelectorOptions()}
        </Input>
        {this.templateDescription()}
      </div>
    );
  },

  templateDescription() {
    if (this.getTemplate(getTemplatedConfigHashCode(this.props.value))) {
      return (
        <Markdown
          source={this.getTemplate(getTemplatedConfigHashCode(this.props.value)).get('description')}
          />
      );
    }
    return null;
  },

  getTemplate(configHashCode) {
    return this.props.templates.filter(
      function(template) {
        return getTemplatedConfigHashCode(template) === parseInt(configHashCode, 10);
      }
    ).first();
  },

  templatesSelectorOptions() {
    return this.props.templates.map(
      function(option) {
        return (
          <option
            value={getTemplatedConfigHashCode(option)}
            key={getTemplatedConfigHashCode(option)}>
            {option.get('name')}
          </option>
        );
      }
    );
  },

  handleSelectorChange() {
    var selectedTemplate = this.getTemplate(this.refs.config.getValue());
    if (selectedTemplate) {
      this.props.onChange(selectedTemplate);
    } else {
      this.props.onChange(Immutable.Map());
    }
  }

});
