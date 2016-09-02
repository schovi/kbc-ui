import React, {PropTypes} from 'react';
import {Link} from 'react-router';
import {getPreviousYearMonth, getNextYearMonth} from '../helpers';

export default React.createClass({

  propTypes: {
    min: PropTypes.string.isRequired,
    max: PropTypes.string.isRequired,
    current: PropTypes.string.isRequired
  },

  getPreviousLink() {
    if (this.props.min !== this.props.current) {
      return (
        <Link to="settings-billing-month" params={{yearMonth: getPreviousYearMonth(this.props.current)}} className="btn btn-primary">
          &larr; Previous month
        </Link>
      );
    } else {
      return (
        <button className="btn btn-primary btn-disabled" disabled="disabled">
          &larr; Previous month
        </button>
      );
    }
  },

  getNextLink() {
    if (this.props.max !== this.props.current) {
      return (
        <Link to="settings-billing-month" params={{yearMonth: getNextYearMonth(this.props.current)}} className="btn btn-primary">
          Next month &rarr;
        </Link>
      );
    } else {
      return (
        <button className="btn btn-primary btn-disabled" disabled="disabled">
          Next month &rarr;
        </button>
      );
    }
  },

  render() {
    return (
      <div>
        {this.getPreviousLink()} {this.getNextLink()}
      </div>
    );
  }

});
