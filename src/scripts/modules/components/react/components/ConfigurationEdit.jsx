import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import CodeMirror from 'react-code-mirror';
import Sticky from 'react-sticky';

/* global require */
require('codemirror/addon/lint/lint');
require('../../../../utils/codemirror/json-lint');

/* global require */
require('./configuration.less');

export default React.createClass({
  propTypes: {
    data: PropTypes.string.isRequired,
    isSaving: PropTypes.bool.isRequired,
    isValid: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
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
      <div className="kbc-configuration-edit">
        <div>
          <div className="edit kbc-configuration-editor">
            <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-60} stickyStyle={{}}>
              <ConfirmButtons
                isSaving={this.props.isSaving}
                onSave={this.props.onSave}
                onCancel={this.props.onCancel}
                placement="right"
                saveLabel={this.props.saveLabel}
                isDisabled={!this.props.isValid}
                />
            </Sticky>
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
          </div>
        </div>
      </div>
    );
  },

  handleChange(e) {
    this.props.onChange(e.target.value);
  }
});
