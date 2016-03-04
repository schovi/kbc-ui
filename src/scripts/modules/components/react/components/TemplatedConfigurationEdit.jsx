import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Sticky from 'react-sticky';
import JSONSchemaEditor from './JSONSchemaEditor';
import JobsEditor from './ConfigurationJobsEditor';
import CodeMirror from 'react-code-mirror';

/* global require */
require('./configuration-json.less');
require('codemirror/addon/lint/lint');
require('../../../../utils/codemirror/json-lint');


export default React.createClass({

  propTypes: {
    jobs: PropTypes.object.isRequired,
    jobsString: PropTypes.string.isRequired,
    jobsTemplates: PropTypes.object.isRequired,
    params: PropTypes.object.isRequired,
    paramsSchema: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    isValid: PropTypes.bool.isRequired,
    isEditingJobsString: PropTypes.bool.isRequired,
    onChangeJobs: PropTypes.func.isRequired,
    onChangeJobsString: PropTypes.func.isRequired,
    onChangeParams: PropTypes.func.isRequired,
    onChangeJobsEditingMode: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    saveLabel: PropTypes.string
  },

  getDefaultProps() {
    return {
      saveLabel: 'Save configuration'
    };
  },

  render() {
    return (
      <div className="kbc-templated-configuration-edit">
        <div>
          <div className="edit kbc-configuration-editor">
            <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-30} stickyStyle={{}}>
              <ConfirmButtons
                isSaving={this.props.isSaving}
                onSave={this.handleSave}
                onCancel={this.props.onCancel}
                placement="right"
                saveLabel={this.props.saveLabel}
                isDisabled={!this.props.isValid}
                />
            </Sticky>
            <JSONSchemaEditor
              ref="paramsEditor"
              schema={this.props.paramsSchema}
              value={this.props.params}
              onChange={this.handleParamsChange}
              readOnly={this.props.isSaving}
            />
            <h3>Endpoints
              {!this.props.isEditingJobsString ? (
                <a className="pull-right" onClick={this.switchToJsonEditor}><small>Switch to JSON editor</small></a>
              ) : null}
            </h3>
            {this.props.isEditingJobsString ? (
              <span>
                <p>Endpoints configuration uses <a href="https://github.com/keboola/generic-extractor#jobs">Jobs notation</a> from Generic Extractor.</p>
                <CodeMirror
                  ref="CodeMirror"
                  value={this.props.jobsString}
                  theme="solarized"
                  lineNumbers={true}
                  mode="application/json"
                  lineWrapping={true}
                  autofocus={true}
                  onChange={this.handleJobsStringChange}
                  readOnly={this.props.isSaving ? 'nocursor' : false}
                  lint={true}
                  gutters={['CodeMirror-lint-markers']}
                  placeholder="[]"
                  />
              </span>
            ) : (
              <JobsEditor
                templates={this.props.jobsTemplates}
                value={this.props.jobs}
                onChange={this.handleJobsChange}
                readOnly={this.props.isSaving}
                />
            )}
          </div>
        </div>
      </div>
    );
  },

  handleJobsChange(value) {
    this.props.onChangeJobs(value);
  },

  handleJobsStringChange(e) {
    this.props.onChangeJobsString(e.target.value);
  },

  handleParamsChange(value) {
    this.props.onChangeParams(value);
  },

  switchToJsonEditor() {
    this.props.onChangeJobsEditingMode(!this.props.isEditingJobsString);
  },

  handleSave() {
    // json-editor doesn't trigger onChange handler on each key stroke
    // so sometimes not actualized data were saved https://github.com/keboola/kbc-ui/issues/501
    this.handleParamsChange(this.refs.paramsEditor.getCurrentValue());
    this.props.onSave();
  }
});
