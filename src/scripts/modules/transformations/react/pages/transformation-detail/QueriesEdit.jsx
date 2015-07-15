import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import CodeMirror from 'react-code-mirror';

export default React.createClass({
  propTypes: {
    queries: PropTypes.string.isRequired,
    backend: PropTypes.string.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  render() {
    return (
      <div>
        <div>
          <div className="well">
            {this.hint()}
          </div>
          <div className="edit form-group">
            <CodeMirror
              value={this.props.queries}
              theme="solarized"
              lineNumbers={true}
              mode={this.editorMode()}
              lineWrapping={true}
              autofocus={true}
              onChange={this.handleChange}
              readOnly={this.props.isSaving}
              placeholder="CREATE VIEW `sample-transformed` AS SELECT `id`  FROM `in.c-main.sample`;"
              />
          </div>
        </div>
        <div>
          <ConfirmButtons
            isSaving={this.props.isSaving}
            onSave={this.props.onSave}
            onCancel={this.props.onCancel}
            placement="left"
            />
        </div>
      </div>
    );
  },

  hint() {
    switch (this.props.backend) {
      case 'redshift':
        return 'Redshift does not support functions or stored procedures.';
      case 'mysql':
        return 'Keboola Connection does not officially support MySQL functions or stored procedures. Use at your own risk.';
    }
  },

  editorMode() {
    switch (this.props.backend) {
      case 'redshift':
        return 'text/x-sql';
      case 'mysql':
        return 'text/x-mysql';
    }
  },

  handleChange(e) {
    this.props.onChange(e.target.value);
  }
});