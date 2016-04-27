import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Sticky from 'react-sticky';
import JSONSchemaEditor from './JSONSchemaEditor';
import TemplateSelector from './ConfigurationTemplateSelector';
import CodeMirror from 'react-code-mirror';

/* global require */
require('./configuration-json.less');
require('codemirror/addon/lint/lint');
require('../../../../utils/codemirror/json-lint');


export default React.createClass({

  propTypes: {
    config: PropTypes.object.isRequired,
    jobsString: PropTypes.string.isRequired,
    mappingsString: PropTypes.string.isRequired,
    templates: PropTypes.object.isRequired,
    params: PropTypes.object.isRequired,
    paramsSchema: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    isValid: PropTypes.bool.isRequired,
    isEditingString: PropTypes.bool.isRequired,
    onChangeTemplate: PropTypes.func.isRequired,
    onChangeJobsString: PropTypes.func.isRequired,
    onChangeMappingsString: PropTypes.func.isRequired,
    onChangeParams: PropTypes.func.isRequired,
    onChangeEditingMode: PropTypes.func.isRequired,
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
            {!this.props.isEditingString ? (
              <h3>Template
                <a className="pull-right" onClick={this.switchToJsonEditor}><small>Switch to JSON editor</small></a>
              </h3>
            ) : null}
            {this.props.isEditingString ? (
              <span>
                <h3>Endpoints</h3>
                <p>Endpoints configuration uses <a href="https://github.com/keboola/generic-extractor#jobs">Jobs notation</a> from Generic Extractor.</p>
                <CodeMirror
                  ref="jobs"
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
                <h3>Mappings</h3>
                <p>Mappings configuration uses <a href="https://github.com/keboola/generic-extractor#mappings">Mappings notation</a> from Generic Extractor.</p>
                <CodeMirror
                  ref="mappings"
                  value={this.props.mappingsString}
                  theme="solarized"
                  lineNumbers={true}
                  mode="application/json"
                  lineWrapping={true}
                  autofocus={false}
                  onChange={this.handleMappingsStringChange}
                  readOnly={this.props.isSaving ? 'nocursor' : false}
                  lint={true}
                  gutters={['CodeMirror-lint-markers']}
                  placeholder="{}"
                  />
              </span>
            ) : (
              <TemplateSelector
                templates={this.props.templates}
                value={this.props.config}
                onChange={this.handleTemplateChange}
                readOnly={this.props.isSaving}
                />
            )}
          </div>
        </div>
      </div>
    );
  },

  handleTemplateChange(value) {
    this.props.onChangeTemplate(value);
  },

  handleJobsStringChange(e) {
    this.props.onChangeJobsString(e.target.value);
  },

  handleMappingsStringChange(e) {
    this.props.onChangeMappingsString(e.target.value);
  },

  handleParamsChange(value) {
    this.props.onChangeParams(value);
  },

  switchToJsonEditor() {
    this.props.onChangeEditingMode(!this.props.isEditingString);
  },

  handleSave() {
    // json-editor doesn't trigger onChange handler on each key stroke
    // so sometimes not actualized data were saved https://github.com/keboola/kbc-ui/issues/501
    this.handleParamsChange(this.refs.paramsEditor.getCurrentValue());
    this.props.onSave();
  }
});
