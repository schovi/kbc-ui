import React, {PropTypes} from 'react';
import Immutable from 'immutable';
import {Input} from 'react-bootstrap';
import Markdown from 'react-markdown';
import fromJSOrdered from '../../../../utils/fromJSOrdered';

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
          value={this.props.value.hashCode()}
          ref="jobs"
          onChange={this.handleSelectorChange}
          disabled={this.props.readOnly}>
          <option value={Immutable.List().hashCode()} disabled>Select template...</option>
          {this.jobsEditorOptions()}
        </Input>
        {this.templateDescription()}
      </div>
    );
  },

  templateDescription() {
    if (this.getTemplate(this.props.value.hashCode())) {
      return (
        <Markdown
          source={this.getTemplate(this.props.value.hashCode()).get('description')}
          />
      );
    }
    return null;
  },

  getTemplate(hashCode) {
    return this.props.templates.filter(
      function(template) {
        return fromJSOrdered(template.get('jobs').toJS()).hashCode() === parseInt(hashCode, 10);
      }
    ).first();
  },

  jobsEditorOptions() {
    return this.props.templates.map(
      function(option) {
        var jobsHash = fromJSOrdered(option.get('jobs').toJS()).hashCode();
        return (
          <option
            value={jobsHash}
            key={jobsHash}>
            {option.get('name')}
          </option>
        );
      }
    );
  },

  handleSelectorChange() {
    var selectedTemplate = this.getTemplate(this.refs.jobs.getValue());
    if (selectedTemplate) {
      this.props.onChange(selectedTemplate.get('jobs'));
    } else {
      this.props.onChange(Immutable.List());
    }
  }

});
