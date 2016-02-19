import React, {PropTypes} from 'react';
import Immutable from 'immutable';
import {Input} from 'react-bootstrap';
import Markdown from 'react-markdown';
import CodeMirror from 'react-code-mirror';

/* global require */
require('./configuration-json.less');
require('codemirror/mode/javascript/javascript');
require('codemirror/addon/lint/lint');
require('../../../../utils/codemirror/json-lint');

export default React.createClass({

  propTypes: {
    value: PropTypes.object.isRequired,
    templates: PropTypes.object,
    readOnly: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired
  },

  getDefaultProps() {
    return {
      templates: Immutable.List()
    };
  },

  getInitialState() {
    return {
      jsonEdit: false
    };
  },

  render() {
    if (this.props.templates && (this.getTemplate(this.props.value.hashCode()) || this.props.value.hashCode() === Immutable.List().hashCode()) && !this.state.jsonEdit) {
      return this.jobsSelector();
    } else {
      return this.jobsJsonEditor();
    }
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

  jobsJsonEditor() {
    return (
      <CodeMirror
        value={JSON.stringify(this.props.value.toJS(), null, 2)}
        theme="solarized"
        lineNumbers={true}
        mode="application/json"
        autofocus={true}
        lineWrapping={true}
        onChange={this.handleEditorChange}
        readOnly={this.props.readOnly}
        lint={true}
        gutters={['CodeMirror-lint-markers']}
        />
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
        return template.get('jobs').hashCode() === parseInt(hashCode, 10);
      }
    ).first();
  },

  jobsEditorOptions() {
    return this.props.templates.map(
      function(option) {
        var jobsHash = option.get('jobs').hashCode();
        return (
          <option
            value={jobsHash}>
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
  },

  handleEditorChange() {
    // TODO freestyle json editor
    // console.log('handleEditorChange', value);
    // this.props.onChange(Immutable.toJS)
    // this.props.onChange(this.getTemplate(this.refs.jobs.getValue()).get('jobs'));
  }

});
