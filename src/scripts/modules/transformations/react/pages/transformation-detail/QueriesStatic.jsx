import React, {PropTypes} from 'react/addons';
import Highlight from './Highlight';
import {OverlayTrigger, Tooltip} from 'react-bootstrap';
import resolveHighlightMode from './resolveHighlightMode';

/* global require */
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

  hasLastQueryLeadingComment(query) {
    var parts = query.split(/\r\n|\r|\n/);
    var last = parts.pop();
    // ^--            : starts with simple comment, e.g. "--"
    // ^ +--          : starts with one ore more empty strings and simple comment, e.g. " --"
    // ^\/\*.*\*\/$   : multi-line command in one line, e.g. "/* whatever */"
    // \*\/$          : ends with multi-line comment, e.g. "*/"
    var regex = /^--|^ +--|^\/\*.*\*\/$|\*\/$/;
    return regex.test(last);
  },

  queryRow(query, index) {
    var showLeadingCommentWarning = (
      this.props.backend === 'redshift'
      && (this.props.queries.count() - 1) === index
      && this.hasLastQueryLeadingComment(query)
    );
    const rowClassName = (index % 2 === 0 ? 'row stripe-odd' : 'row')
        + (showLeadingCommentWarning ? ' stripe-query-has-comment' : '');
    var warning;
    if (showLeadingCommentWarning) {
      warning = (
        <div className="col-md-1 vertical-center">
          <OverlayTrigger overlay={<Tooltip>Queries containing comments at the end may fail
          execution. Remove trailing comments, please.</Tooltip>}>
          <i className="fa fa-exclamation-triangle"/>
          </OverlayTrigger>
        </div>
      );
    } else {
      warning = '';
    }

    return (
      <div className={rowClassName} key={index}>
        <div className="col-md-1 vertical-center query-number noselect">
          <span data-query-number={index + 1} className="query-number-value"/>
          <OverlayTrigger overlay={<Tooltip>Edit Query</Tooltip>}>
            <span className="btn btn-link query-edit" onClick={this.startEdit.bind(this, index)}>
              <span className="kbc-icon-pencil"/>
            </span>
          </OverlayTrigger>
        </div>
        <div className={showLeadingCommentWarning ? 'col-md-10 vertical-center' : 'col-md-11 vertical-center'}>
          <span className="static">
            <Highlight
              script={query}
              mode={resolveHighlightMode(this.props.backend, null)}
              />
          </span>
        </div>
        {warning}
      </div>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.startEdit.bind(this, 0)}>
        <span className="kbc-icon-pencil" /> Edit Queries
      </button>
    );
  },

  startEdit(queryNumber) {
    this.props.onEditStart(queryNumber);
  }
});
