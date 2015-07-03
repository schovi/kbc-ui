import React from 'react/addons';
import createStoreMixin from '../mixins/createStoreMixin';
import NotificationsStore from '../../stores/NotificationsStore';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';
import {Alert} from 'react-bootstrap';

const CSSTransitionGroup = React.addons.CSSTransitionGroup;

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
    console.log('nofs', this.state.notifications.toJS());
    return (
      <div className="kbc-notifications">
        <CSSTransitionGroup transitionName="kbcNotificationTransition">
          {this.state.notifications.map(this.renderNotification)}
        </CSSTransitionGroup>
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
    if (typeof notification.get('value') === 'string') {
      return notification.get('value');
    } else {
      return React.createElement(notification.get('value'), {
        onClick: this.handleDismiss.bind(this, notification.get('id'))
      });
    }
  },

  handleDismiss(id) {
    ApplicationActionCreators.deleteNotification(id);
  }

});