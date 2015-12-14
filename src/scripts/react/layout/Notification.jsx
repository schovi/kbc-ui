import React from 'react';
import {Alert} from 'react-bootstrap';

const classMap = {
  success: 'info',
  error: 'danger'
};

function computeNotificationAge(notification) {
  return new Date().getTime() - notification.get('created').getTime();
}

export default React.createClass({
  propTypes: {
    notification: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired
  },

  getInitialState() {
    return {
      age: computeNotificationAge(this.props.notification)
    };
  },

  tick: function() {
    this.setState({
      age: computeNotificationAge(this.props.notification)
    });
  },
  componentDidMount: function() {
    this.interval = setInterval(this.tick, 100);
  },
  componentWillUnmount: function() {
    clearInterval(this.interval);
  },

  render() {
    const {notification} = this.props;
    return (
      <div >
        <Alert
          onDismiss={this.onCancel}
          bsStyle={classMap[notification.get('type')]}
          style={this.opacity()}
          >
          {this.renderNotificationBody(notification)}
        </Alert>
      </div>
    );
  },

  opacity() {
    const timeout = this.props.notification.get('timeout'),
      age = this.state.age,
      animationStartRatio = 0.6;
    if (age / timeout < animationStartRatio) {
      return {
        opacity: 1
      };
    }

    const animationTime = Math.round((1 - animationStartRatio) * timeout);
    return {
      opacity: 0.4,
      transition: `opacity ${animationTime}ms ease-in`
    };
  },

  renderNotificationBody(notification) {
    if (typeof notification.get('message') === 'string') {
      return notification.get('message');
    }
    return React.createElement(notification.get('message'), {
      onClick: this.onCancel
    });
  },

  onCancel() {
    this.props.onCancel(this.props.notification.get('id'));
  }

});