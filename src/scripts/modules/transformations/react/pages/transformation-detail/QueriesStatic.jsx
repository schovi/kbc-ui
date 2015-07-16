import React, {PropTypes} from 'react/addons';
import Highlight from './Highlight';

/*global require */
require('codemirror/mode/sql/sql');

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    queries: PropTypes.object.isRequired,
    backend: PropTypes.object.isRequired,
    onEditStart: PropTypes.func.isRequired
  },

  render() {
    console.log('render static');
    return this.props.queries.count() ? this.queriesList() : this.emptyState();
  },

  queriesList() {
    return (
      <div>
        <div>
          {this.props.queries.map(this.queryRow, this)}
        </div>
        <div>{this.startEditButton()}</div>
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
          {index + 1}
          <span className="btn btn-link query-edit" onClick={this.startEdit.bind(this, index)}>
            <span className="kbc-icon-pencil"/>
          </span>
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
      case 'mysql':
        return 'text/x-mysql';
    }
  },

  startEdit(queryNumber) {
    this.props.onEditStart(queryNumber);
  }
});
