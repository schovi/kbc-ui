import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import CodeMirror from 'react-code-mirror';
import Sticky from 'react-sticky';
import JSONSchemaEditor from './JSONSchemaEditor';
import Immutable from 'immutable';

/* global require */
require('codemirror/addon/lint/lint');
require('../../../../utils/codemirror/json-lint');

/* global require */
require('./configuration.less');

export default React.createClass({
  propTypes: {
    data: PropTypes.string.isRequired,
    schema: PropTypes.string,
    isSaving: PropTypes.bool.isRequired,
    isValid: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    saveLabel: PropTypes.string,
    supportsEncryption: PropTypes.bool
  },

  getDefaultProps() {
    return {
      saveLabel: 'Save configuration',
      supportsEncryption: false,
      schema: Immutable.Map()
    };
  },

  render() {
    return (
      <div>
        <div className="edit kbc-configuration-editor">
          <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-60} stickyStyle={{}}>
            <ConfirmButtons
              isSaving={this.props.isSaving}
              onSave={this.handleSave}
              onCancel={this.props.onCancel}
              placement="right"
              saveLabel={this.props.saveLabel}
              isDisabled={!this.props.isValid}
              />
          </Sticky>
          {this.renderJSONSchemaEditor()}
          {this.renderCodeMirror()}

        </div>
      </div>
    );
  },

  renderJSONSchemaEditor() {
    if (this.props.schema.isEmpty()) {
      return null;
    }
    return (
      <JSONSchemaEditor
        ref="paramsEditor"
        schema={this.props.schema}
        value={Immutable.fromJS(JSON.parse(this.props.data))}
        onChange={this.handleParamsChange}
        readOnly={this.props.isSaving}
        disableCollapse={true}
        disableProperties={true}
      />
    );
  },

  renderCodeMirror() {
    if (!this.props.schema.isEmpty()) {
      return null;
    }
    return (
      <span>
        {this.props.supportsEncryption ? (<p className="help-block small">Properties prefixed with <code>#</code> sign will be encrypted on save. Already encrypted strings will persist.</p>) : null}
        <CodeMirror
          value={this.props.data}
          theme="solarized"
          lineNumbers={true}
          mode="application/json"
          autofocus={true}
          lineWrapping={true}
          onChange={this.handleChange}
          readOnly={this.props.isSaving}
          lint={true}
          gutters={['CodeMirror-lint-markers']}
          />
      </span>
    );
  },

  handleChange(e) {
    this.props.onChange(e.target.value);
  },

  handleParamsChange(value) {
    this.props.onChange(JSON.stringify(value));
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
