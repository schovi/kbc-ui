import React, {PropTypes} from 'react';
import Immutable from 'immutable';
import {Input} from 'react-bootstrap';
import Markdown from 'react-markdown';
import templateFinder from '../../../components/utils/templateFinder';
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
    var selectedDefault = false;
    if (!this.props.value || this.props.value.isEmpty()) {
      selectedDefault = true;
    }
    return (
      <div>
        <Input
          type="select"
          ref="config"
          onChange={this.handleSelectorChange}
          disabled={this.props.readOnly}>
          <option
            value={Immutable.List().hashCode()}
            disabled
            selected={selectedDefault}
          >Select template...</option>
          {this.templatesSelectorOptions()}
        </Input>
        {this.templateDescription()}
      </div>
    );
  },

  templateDescription() {
    if (this.props.value) {
      return (
        <Markdown
          source={this.props.value.get('description')}
          />
      );
    }
    return null;
  },

  getTemplate(value) {
    return templateFinder(this.props.templates, value.get('data')).first();
  },

  templatesSelectorOptions() {
    return this.props.templates.map(
      function(option) {
        var selected = deepEqual(option.toJS(), this.props.value.toJS());
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
    , this);
  },

  handleSelectorChange() {
    var selectedTemplate = Immutable.fromJS(JSON.parse(this.refs.config.getValue()));
    if (selectedTemplate) {
      this.props.onChange(selectedTemplate);
    } else {
      this.props.onChange(Immutable.Map());
    }
  }

});
