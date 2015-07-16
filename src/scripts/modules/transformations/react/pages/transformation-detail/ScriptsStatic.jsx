import React, {PropTypes} from 'react';
import CodeMirror from 'react-code-mirror';

export default React.createClass({
  propTypes: {
    script: PropTypes.string.isRequired
  },

  render() {
    return this.props.script && this.props.script.length ? this.script() : this.emptyState();
  },

  script() {
    return (
      <div>
        <div>
          <CodeMirror
            theme="solarized"
            lineNumbers={true}
            defaultValue={this.props.script}
            readOnly="nocursor"
            mode="text/x-rsrc"
            lineWrapping={true}
            />
        </div>
        <div>
          {this.startEditButton()}
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
