import React, {PropTypes} from 'react/addons';
import Static from './QueriesStatic';
import Edit from './QueriesEdit';
import Clipboard from '../../../../../react/common/Clipboard';
import string from 'underscore.string';

/*global require */
require('codemirror/mode/sql/sql');

function getQueryPosition(queries, queryNumber) {
  return queries
    .take(queryNumber)
    .reduce((total, query) => {
      return total + string.lines(query).length + 1;
    }, 0);
}

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
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

  getInitialState() {
    return {
      cursorPos: 0
    };
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
          cursorPos={this.state.cursorPos}
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
          backend={this.props.transformation.get('backend')}
          onEditStart={this.handleEditStart}
          />
      );
    }
  },

  handleEditStart(queryNumber) {
    if (queryNumber) {
      this.setState({
        cursorPos: getQueryPosition(this.props.transformation.get('queries'), queryNumber)
      });
    }
    this.props.onEditStart();
  }

});
