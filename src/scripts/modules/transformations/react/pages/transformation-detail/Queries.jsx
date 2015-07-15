import React, {PropTypes} from 'react';
import Static from './QueriesStatic';
import Edit from './QueriesEdit';
import Clipboard from '../../../../../react/common/Clipboard';

/*global require */
require('codemirror/mode/sql/sql');

export default React.createClass({
  propTypes: {
    bucketId: PropTypes.string.isRequired,
    transformation: PropTypes.object.isRequired,
    queries: PropTypes.string.isRequired,
    isEditing: PropTypes.bool.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onEditStart: PropTypes.func.isRequired,
    onEditCancel: PropTypes.func.isRequired,
    onEditChange: PropTypes.func.isRequired,
    onEditSubmit: PropTypes.func.isRequired
  },

  render() {
    return (
      <div>
        <h2>
          Queries <small><Clipboard text={this.props.queries}/></small>
        </h2>
        {this.queries()}
      </div>
    );
  },

  queries() {
    if (this.props.isEditing) {
      return (
        <Edit
          queries={this.props.queries}
          backend={this.props.transformation.get('backend')}
          isSaving={this.props.isSaving}
          onSave={this.props.onEditSubmit}
          onChange={this.props.onEditChange}
          onCancel={this.props.onEditCancel}
          />
      );
    } else {
      return (
        <Static
          queries={this.props.transformation.get('queries')}
          onEditStart={this.props.onEditStart}
          />
      );
    }
  }

});