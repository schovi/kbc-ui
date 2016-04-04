import React from 'react';
import moment from 'moment';
import {Tooltip} from './common';

export default React.createClass({
  displayName: 'CreatedWithIcon',

  propTypes: {
    createdTime: React.PropTypes.string
  },

  render: function() {
    return (
      <span>
        <Tooltip tooltip={this.props.createdTime}>
          <i className="fa fa-fw fa-calendar"> </i>
        </Tooltip>
        {moment(this.props.createdTime).fromNow()}
      </span>
    );
  }
});
