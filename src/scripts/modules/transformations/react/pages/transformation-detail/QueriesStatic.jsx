import React, {PropTypes} from 'react/addons';
import CodeMirror from 'react-code-mirror';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    queries: PropTypes.object.isRequired,
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
          <button className="btn btn-link" onClick={this.startEdit.bind(this, index)}>
            <span className="kbc-icon-pencil"/> Edit Query
          </button>
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

  startEdit(queryNumber) {
    this.props.onEditStart(queryNumber);
  }
});