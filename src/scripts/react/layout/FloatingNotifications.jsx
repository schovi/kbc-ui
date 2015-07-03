import React from 'react';
import createStoreMixin from '../mixins/createStoreMixin';
import NotificationsStore from '../../stores/NotificationsStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';
import {Alert} from 'react-bootstrap';

const classMap = {
  success: 'success',
  error: 'danger'
};

export default React.createClass({
  mixins: [createStoreMixin(NotificationsStore)],

  getStateFromStores() {
    return {
      notifications: NotificationsStore.getNotifications()
    };
  },

  render() {
    return (
      <div className="kbc-notifications">
        {this.state.notifications.map(this.renderNotification)}
      </div>
    );
  },

  renderNotification(notification, index) {
    return (
      <div>
        <Alert
          key={index}
          onDismiss={this.handleDismiss.bind(this, index)}
          bsStyle={classMap[notification.get('type')]}
          >
          {this.renderNotificationBody(notification, index)}
        </Alert>
      </div>
    );
  },

  renderNotificationBody(notification, index) {
    if (typeof notification.get('value') === 'string') {
      return notification.get('value');
    } else {
      return React.createElement(notification.get('value'), {
        onClick: this.handleDismiss.bind(this, index)
      });
    }
  },

  handleDismiss(index) {
    ApplicationActionCreators.deleteNotification(index);
  }

});