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
    editingTemplate: PropTypes.object.isRequired,
    editingParams: PropTypes.object.isRequired,
    editingString: PropTypes.string.isRequired,

    templates: PropTypes.object.isRequired,
    paramsSchema: PropTypes.object.isRequired,
    isEditingString: PropTypes.bool.isRequired,

    isValid: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,

    onChangeTemplate: PropTypes.func.isRequired,
    onChangeParams: PropTypes.func.isRequired,
    onChangeString: PropTypes.func.isRequired,
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

  renderJSONSchemaEditor() {
    // empty json schema does not render
    if (!this.props.paramsSchema.get('properties') || this.props.paramsSchema.get('properties').count() === 0) {
      return null;
    }
    return (
      <JSONSchemaEditor
        ref="paramsEditor"
        schema={this.props.paramsSchema}
        value={this.props.editingParams}
        onChange={this.handleParamsChange}
        readOnly={this.props.isSaving}
      />
    );
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
            {this.props.isEditingString ? (
              <span>
                <p className="kbc-template-editor-toggle"><a onClick={this.switchToTemplateEditor}><small>Switch to templates</small></a></p>
                <p>Configuration uses <a href="https://github.com/keboola/generic-extractor">Generic extractor</a> format.</p>
                <CodeMirror
                  ref="string"
                  value={this.props.editingString}
                  theme="solarized"
                  lineNumbers={true}
                  mode="application/json"
                  lineWrapping={true}
                  autofocus={true}
                  onChange={this.handleStringChange}
                  readOnly={this.props.isSaving ? 'nocursor' : false}
                  lint={true}
                  gutters={['CodeMirror-lint-markers']}
                  placeholder="{}"
                  />
              </span>
            ) : (
              <span>
                <p className="kbc-template-editor-toggle"><a onClick={this.switchToJsonEditor}><small>Switch to JSON editor</small></a></p>
                {this.renderJSONSchemaEditor()}
                <h3>Template</h3>
                <TemplateSelector
                  templates={this.props.templates}
                  value={this.props.editingTemplate}
                  onChange={this.handleTemplateChange}
                  readOnly={this.props.isSaving}
                  />
                </span>
            )}
          </div>
        </div>
      </div>
    );
  },

  handleTemplateChange(value) {
    this.props.onChangeTemplate(value);
  },

  handleStringChange(e) {
    this.props.onChangeString(e.target.value);
  },

  handleParamsChange(value) {
    this.props.onChangeParams(value);
  },

  switchToJsonEditor() {
    this.props.onChangeEditingMode(true);
  },

  switchToTemplateEditor() {
    this.props.onChangeEditingMode(false);
  },

  handleSave() {
    if (this.refs.paramsEditor) {
      // json-editor doesn't trigger onChange handler on each key stroke
      // so sometimes not actualized data were saved https://github.com/keboola/kbc-ui/issues/501
      this.handleParamsChange(this.refs.paramsEditor.getCurrentValue());
    }
    this.props.onSave();
  }
});
