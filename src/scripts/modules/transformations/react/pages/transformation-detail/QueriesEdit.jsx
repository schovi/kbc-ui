import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import CodeMirror from 'react-code-mirror';
import Sticky from 'react-sticky';
import resolveHighlightMode from './resolveHighlightMode';

/* global require */
require('./queries.less');

export default React.createClass({
  propTypes: {
    queries: PropTypes.string.isRequired,
    cursorPos: PropTypes.number.isRequired,
    backend: PropTypes.string.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  componentDidMount() {
    if (this.props.cursorPos) {
      this.refs.CodeMirror.editor.setCursor(this.props.cursorPos);
      /* global window */
      window.scrollTo(this.refs.CodeMirror.editor.cursorCoords().left,
        this.refs.CodeMirror.editor.cursorCoords().top - 100);
    }
  },

  render() {
    return (
      <div className="kbc-queries-edit">
        <div>
          <div className="edit form-group kbc-queries-editor">
            <Sticky stickyClass="kbc-sticky-buttons-active" topOffset={-60} stickyStyle={{}}>
              <div className="text-right">
                <ConfirmButtons
                  isSaving={this.props.isSaving}
                  onSave={this.props.onSave}
                  onCancel={this.props.onCancel}
                  placement="right"
                  saveLabel="Save Queries"
                  />
              </div>
            </Sticky>
            <CodeMirror
              ref="CodeMirror"
              value={this.props.queries}
              theme="solarized"
              lineNumbers={true}
              cursorPos={this.props.cursorPos}
              mode={resolveHighlightMode(this.props.backend, null)}
              lineWrapping={true}
              autofocus={true}
              onChange={this.handleChange}
              readOnly={this.props.isSaving ? 'nocursor' : false}
              placeholder="CREATE VIEW `sample-transformed` AS SELECT `id`  FROM `in.c-main.sample`;"
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
