import React, {PropTypes} from 'react';
import CodeMirror from 'react-code-mirror';

export default React.createClass({
  propTypes: {
    data: PropTypes.string.isRequired
  },

  render() {
    return this.props.data && this.props.data.length ? this.script() : this.emptyState();
  },

  script() {
    return (
      <div className="kbc-configuration-edit">
        <div className="edit kbc-configuration-editor">
          <div className="kbc-sticky-buttons">
            {this.startEditButton()}
          </div>
          <CodeMirror
            theme="solarized"
            lineNumbers={true}
            defaultValue={this.props.data}
            readOnly={true}
            cursorHeight={0}
            mode="application/json"
            lineWrapping={true}
            />
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <p>
        <small>No configuration.</small> {this.startEditButton()}
      </p>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> Edit configuration
      </button>
    );
  }
});
