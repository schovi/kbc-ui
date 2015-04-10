React = require 'react'
{Map} = require 'immutable'
ItemsListEditor = require '../../../../../react/common/ItemsListEditor'

{div, h2, p, span, strong} = React.DOM

SubscribersList = React.createClass
  displayName: 'SubscribersList'
  propTypes:
    emails: React.PropTypes.object.isRequired
  render: ->
    if @props.emails.count()
      div null,
        strong null,
          'Subscribers: '
        span null,
          @props.emails.map (email) ->
            span
              key: email.get 'email'
            ,
              email.get 'email'
              ' '
          .toArray()
    else
      span null,
        'No subsribers yet.'

module.exports = React.createClass
  displayName: 'Notifications'
  propTypes:
    notifications: React.PropTypes.object.isRequired # notifications in structure from API
    inputs: React.PropTypes.object.isRequired # map of inputs for each channel
    isEditing: React.PropTypes.bool.isRequired
    onNotificationsChange: React.PropTypes.func.isRequired
    onInputChange: React.PropTypes.func.isRequired
  render: ->
    errorEmails = @_getNotificationsForChannel 'error'
    processingEmails = @_getNotificationsForChannel 'processing'
    div null,
      div null,
        p null,
          'You can subscribe to some events in orchestration jobs processing.'
      div null,
        h2 null, 'Errors'
          p null,
            'Notified when the orchestration finished with error.'
          if @props.isEditing
            @_renderNotificationsEditor 'error', errorEmails
          else
            React.createElement SubscribersList,
              emails: errorEmails
      div null,
        h2 null, 'Processing'
          p null,
            'Notified when job is still processing, abnormally longer than usually.'
          if @props.isEditing
            @_renderNotificationsEditor 'processing', processingEmails
          else
            React.createElement SubscribersList,
              emails: processingEmails

  _renderNotificationsEditor: (channelName, emails) ->
    React.createElement ItemsListEditor,
      value: emails.map (email) -> email.get 'email'
      input: @props.inputs.get channelName
      disabled: false
      inputPlaceholder: 'Enter email ...'
      emptyText: 'No subsribers yet.'
      onChangeValue: @_onChannelChange.bind @, channelName
      onChangeInput: @_onInputChange.bind @, channelName

  _onInputChange: (channelName, newValue) ->
    @props.onInputChange channelName, newValue

  _onChannelChange: (channelName, newEmails) ->
    newNotifications = newEmails.map (email) ->
      Map
        email: email
        channel: channelName
        parameters: {}

    newNotifications = @props.notifications.filter (notification) ->
      notification.get('channel') != channelName
    .concat newNotifications

    @props.onNotificationsChange newNotifications


  _getNotificationsForChannel: (channelName) ->
    @props.notifications.filter (notification) ->
      notification.get('channel') == channelName
