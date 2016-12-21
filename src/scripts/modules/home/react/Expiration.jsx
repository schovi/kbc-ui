import React from 'react';
import moment from 'moment';
import contactSupport from '../../../utils/contactSupport';
import './expiration.less';
import IntlMessageFormat from 'intl-messageformat';

const MESSAGES = {
  DAYS: '{days, plural, ' +
  '=0 {less than a day}' +
  '=1 {# day}' +
  'other {# days}}'
};

export default React.createClass({
  propTypes: {
    expires: React.PropTypes.string.isRequired
  },

  render() {
    const {expires} = this.props;

    if (!expires || parseInt(this.days(), 10) > 30) {
      return null;
    }

    return (
      <div className="row kbc-header kbc-expiration">
        <div className="alert alert-warning">
          <h3>
            <span className="fa fa-exclamation-triangle"/>This project will expire in {this.days()}.
          </h3>
          <p>Please <a onClick={contactSupport}>contact support</a> for project plan upgrade.</p>
        </div>
      </div>
    );
  },

  days() {
    // Math.round is used for compatibility with ranges computed by backend (settings page)
    return new IntlMessageFormat(MESSAGES.DAYS).format({
      days: Math.max(0, Math.round(moment(this.props.expires).diff(moment(), 'days', true)))
    });
  }
});
