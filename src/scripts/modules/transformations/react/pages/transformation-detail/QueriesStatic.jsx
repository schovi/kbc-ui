import React, {PropTypes} from 'react';
import CodeMirror from 'react-code-mirror';

export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired
  },

  render() {
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
        <div className="col-md-1 vertical-center">
          {index + 1}
        </div>
        <div className="col-md-11 vertical-center">
          <span className="static">
            <CodeMirror
              theme="solarized"
              lineNumbers={false}
              value={query}
              readOnly="nocursor"
              mode="text/x-mysql"
              lineWrapping={true}
              />
          </span>
        </div>
      </div>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> Edit Queries
      </button>
    );
  }
});