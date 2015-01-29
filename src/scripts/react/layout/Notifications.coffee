React = require 'react'
createStoreMixin = require '../../react/mixins/createStoreMixin.coffee'
NotificationsStore = require '../../stores/NotificationsStore.coffee'
ApplicationActionCreators = require '../../actions/ApplicationActionCreators.coffee'

Alert = React.createFactory(require('react-bootstrap').Alert)


{div} = React.DOM

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
          bsStyle: 'success'
          onDismiss: @_handleAlertDismiss.bind(@, index)
        ,
          notification.get 'value'
      , @
      .toArray()

