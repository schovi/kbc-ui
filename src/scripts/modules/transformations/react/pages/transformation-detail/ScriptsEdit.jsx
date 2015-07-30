import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import CodeMirror from 'react-code-mirror';
import Sticky from 'react-sticky';

/* global require */
require('./queries.less');

export default React.createClass({
  propTypes: {
    script: PropTypes.string.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="kbc-queries-edit">
        <div>
          <div className="well">
            Read on <a href="https://sites.google.com/a/keboola.com/wiki/home/keboola-connection/devel-space/transformations/backends/docker/r-limitations-and-best-practices">
              R limitations and best practices
            </a>.
          </div>
          <div className="well">
            All source tables are stored in <code>/data/in/tables</code>
            (relative path <code>in/tables</code>, save all tables for output mapping to
            <code>/data/out/tables</code> (relative path <code>out/tables</code>).
          </div>
          <div className="edit form-group kbc-queries-editor">
            <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-60} stickyStyle={{}}>
              <ConfirmButtons
                isSaving={this.props.isSaving}
                onSave={this.props.onSave}
                onCancel={this.props.onCancel}
                placement="right"
                saveLabel="Save Scripts"
                />
            </Sticky>
            <CodeMirror
              value={this.props.script}
              theme="solarized"
              lineNumbers={true}
              mode="text/x-rsrc"
              autofocus={true}
              lineWrapping={true}
              onChange={this.handleChange}
              readOnly={this.props.isSaving}
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
