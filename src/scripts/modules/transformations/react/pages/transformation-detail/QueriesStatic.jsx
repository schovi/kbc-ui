import React, {PropTypes} from 'react/addons';
import Highlight from './Highlight';

/*global require */
require('codemirror/mode/sql/sql');

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    queries: PropTypes.object.isRequired,
    backend: PropTypes.string.isRequired,
    onEditStart: PropTypes.func.isRequired
  },

  render() {
    return this.props.queries.count() ? this.queriesList() : this.emptyState();
  },

  queriesList() {
    return (
      <div>
        <div className="text-right">{this.startEditButton()}</div>
        <div>
          {this.props.queries.map(this.queryRow, this)}
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <p>
        <small>No SQL queries.</small> {this.startEditButton()}
      </p>
    );
  },

  queryRow(query, index) {
    const rowClassName = index % 2 === 0 ? 'row stripe-odd' : 'row';
    return (
      <div className={rowClassName} key={index}>
        <div className="col-md-1 vertical-center query-number noselect">
          <span data-query-number={index + 1} className="query-number-value"/>
        </div>
        <div className="col-md-11 vertical-center">
          <span className="static">
            <Highlight script={query} mode={this.editorMode()} />
          </span>
        </div>
      </div>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.startEdit.bind(this, 0)}>
        <span className="kbc-icon-pencil"></span> Edit Queries
      </button>
    );
  },

  editorMode() {
    switch (this.props.backend) {
      case 'redshift':
        return 'text/x-sql';
      case 'snowflake':
        return 'text/x-sql';
      case 'mysql':
        return 'text/x-mysql';
    }
  },

  startEdit(queryNumber) {
    this.props.onEditStart(queryNumber);
  }
});
