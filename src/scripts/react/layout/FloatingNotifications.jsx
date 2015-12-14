import React from 'react/addons';
import createStoreMixin from '../mixins/createStoreMixin';
import NotificationsStore from '../../stores/NotificationsStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';
import Notification from './Notification';

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
        {this.state.notifications.map((notification) => {
          return React.createElement(Notification, {
            key: notification.get('id'),
            notification: notification,
            onCancel: this.handleCancel
          });
        })}
      </div>
    );
  },

  handleCancel(id) {
    ApplicationActionCreators.deleteNotification(id);
  }

});