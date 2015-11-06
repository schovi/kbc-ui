import React, {PropTypes} from 'react';
import CodeMirror from 'react-code-mirror';

export default React.createClass({
  propTypes: {
    script: PropTypes.string.isRequired,
    onEditStart: PropTypes.func.isRequired
  },

  render() {
    return this.props.script && this.props.script.length ? this.script() : this.emptyState();
  },

  script() {
    return (
      <div className="kbc-queries-edit">
        <div className="text-right">{this.startEditButton()}</div>
        <div className="edit form-group kbc-queries-editor">
          <CodeMirror
            theme="solarized"
            lineNumbers={true}
            defaultValue={this.props.script}
            readOnly={true}
            cursorHeight={0}
            mode="text/x-rsrc"
            lineWrapping={true}
            />
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <p>
        <small>No R script.</small> {this.startEditButton()}
      </p>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> Edit R Script
      </button>
    );
  }
});
