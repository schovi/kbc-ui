import React, {PropTypes} from 'react/addons';
import Static from './QueriesStatic';
import Edit from './QueriesEdit';
import Clipboard from '../../../../../react/common/Clipboard';
import string from 'underscore.string';
import {OverlayTrigger, Popover} from 'react-bootstrap';

/* global require */
require('codemirror/mode/sql/sql');
require('./queries.less');

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
    isEditingValid: PropTypes.bool.isRequired,
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
          Queries
          <small>
            <OverlayTrigger trigger="hover" placement="top" overlay={this.hint()}>
              <i className="fa fa-fw fa-question-circle" />
            </OverlayTrigger>
            <Clipboard text={this.props.queries}/>
          </small>
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
          isValid={this.props.isEditingValid}
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
    this.setState({
      cursorPos: getQueryPosition(this.props.transformation.get('queries'), queryNumber)
    });
    this.props.onEditStart();
  },

  hint() {
    switch (this.props.transformation.get('backend')) {
      case 'redshift':
        return (
          <Popover title="Redshift queries" className="popover-wide">
            <ul>
              <li>Comments after the last query or comments longer than 8000 characters will fail execution.</li>
              <li>Do not use plain SELECT queries as they do not modify data and may exhaust memory on the cluster or in our component; use appropriate CREATE, UPDATE, INSERT or DELETE.</li>
              <li>Redshift does not support functions or stored procedures.</li>
            </ul>
          </Popover>);
      case 'snowflake':
        return (
          <Popover title="Snowflake queries" className="popover-wide">
            <ul>
              <li>Comments after the last query or comments longer than 8000 characters will fail execution.</li>
              <li>Do not use plain SELECT queries as they do not modify data and may exhaust memory on the cluster or in our component; use appropriate CREATE, UPDATE, INSERT or DELETE.</li>
              <li>Working with timestamps? Please read the <a href="https://help.keboola.com/manipulation/transformations/snowflake/#timestamp-columns">documentation</a>.</li>
            </ul>
          </Popover>);
      default:
        return (
          <Popover title="Mysql queries" className="popover-wide">
            <ul>
              <li>Comments after the last query or comments longer than 8000 characters will fail execution.</li>
              <li>Do not use plain SELECT queries as they do not modify data and may exhaust memory on the cluster or in our component; use appropriate CREATE, UPDATE, INSERT or DELETE.</li>
              <li>MySQL functions or stored procedures are not officially supported. Use at your own risk.</li>
            </ul>
          </Popover>);
    }
  }


});
