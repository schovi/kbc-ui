import React from 'react/addons';
import createStoreMixin from '../mixins/createStoreMixin';
import NotificationsStore from '../../stores/NotificationsStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';
import {Alert} from 'react-bootstrap';

const classMap = {
  success: 'info',
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

  renderNotification(notification) {
    return (
      <div key={notification.get('id')}>
        <Alert
          onDismiss={this.handleDismiss.bind(this, notification.get('id'))}
          bsStyle={classMap[notification.get('type')]}
          >
          {this.renderNotificationBody(notification)}
        </Alert>
      </div>
    );
  },

  renderNotificationBody(notification) {
    if (typeof notification.get('message') === 'string') {
      return notification.get('message');
    }
    return React.createElement(notification.get('message'), {
      onClick: this.handleDismiss.bind(this, notification.get('id'))
    });
  },

  handleDismiss(id) {
    ApplicationActionCreators.deleteNotification(id);
  }

});