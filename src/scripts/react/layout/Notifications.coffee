React = require 'react'
createStoreMixin = require '../../react/mixins/createStoreMixin'
NotificationsStore = require '../../stores/NotificationsStore'
ApplicationActionCreators = require '../../actions/ApplicationActionCreators'

Alert = React.createFactory(require('react-bootstrap').Alert)


{div, span} = React.DOM

classMap =
  success: 'success'
  error: 'danger'

module.exports = React.createClass
  displayName: 'Notifications'
  mixins: [createStoreMixin(NotificationsStore)]

  getStateFromStores: ->
    notifications: NotificationsStore.getNotifications()

  _handleAlertDismiss: (index) ->
    ApplicationActionCreators.deleteNotification index

  render: ->
    div null,
      @state.notifications.map (notification, index) ->
        Alert
          key: index
          bsStyle: classMap[notification.get 'type']
          onDismiss: @_handleAlertDismiss.bind(@, index)
        ,
          if typeof notification.get('value') == 'string'
            notification.get 'value'
          else
            React.createElement notification.get('value'),
              onClick: @_handleAlertDismiss.bind(@, index)
      , @
      .toArray()
