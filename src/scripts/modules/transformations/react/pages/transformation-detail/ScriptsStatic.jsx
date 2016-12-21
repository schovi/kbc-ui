import React, {PropTypes} from 'react';
import CodeMirror from 'react-code-mirror';
import resolveHighlightMode from './resolveHighlightMode';

export default React.createClass({
  propTypes: {
    script: PropTypes.string.isRequired,
    transformationType: PropTypes.string.isRequired,
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
            mode={resolveHighlightMode('docker', this.props.transformationType)}
            lineWrapping={true}
            />
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <p>
        {this.props.transformationType === 'r' ? (<small>No R script.</small>) : null}
        {this.props.transformationType === 'python' ? (<small>No Python script.</small>) : null}
        {this.props.transformationType === 'openrefine' ? (<small>No OpenRefine configuration.</small>) : null}
        {this.startEditButton()}
      </p>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil" />
          {this.props.transformationType === 'r' ? 'Edit R script' : null}
          {this.props.transformationType === 'python' ? 'Edit Python script' : null}
          {this.props.transformationType === 'openrefine' ? 'Edit OpenRefine configuration' : null}
      </button>
    );
  }
});
