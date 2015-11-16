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
    console.log 'render', @props.notifications.toJS()
    errorEmails = @_getNotificationsForChannel 'error'
    warningEmails = @_getNotificationsForChannel 'warning'
    processingEmails = @_getNotificationsForChannel 'processing'

    div {className: 'kbc-block-with-padding'},
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
        h2 null, 'Warnings'
          p null,
            'Notified when the orchestration finished with warning.'
          if @props.isEditing
            @_renderNotificationsEditor 'warning', warningEmails
          else
            React.createElement SubscribersList,
              emails: warningEmails
      div null,
        h2 null, 'Processing'
        if @props.isEditing && processingEmails.count()
          p null,
            'Notified when job is processing '
            @_renderToleranceInput()
            ' % longer than usually.'
        else
          p null,
            'Notified when job is processing '
            @_getTolerance()
            '% longer than usually.'
        if @props.isEditing
          @_renderNotificationsEditor 'processing', processingEmails
        else
          React.createElement SubscribersList,
            emails: processingEmails

  _renderToleranceInput: ->
    React.DOM.input
      type: 'number'
      value: @_getTolerance()
      onChange: @_onToleranceChange
      className: 'form-control'
      style:
        width: '80px'
        display: 'inline-block'

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
    tolerance = @_getTolerance()
    newNotifications = newEmails.map (email) ->
      Map
        email: email
        channel: channelName
        parameters: Map
          tolerance: tolerance if channelName == 'processing'

    newNotifications = @props.notifications.filter (notification) ->
      notification.get('channel') != channelName
    .concat newNotifications

    @props.onNotificationsChange newNotifications

  _onToleranceChange: (e) ->
    tolerance = parseInt(e.target.value)
    newNotifications = @props.notifications.map (notification) ->
      if notification.get('channel') != 'processing'
        notification
      else
        notification.setIn ['parameters', 'tolerance'], tolerance
    @props.onNotificationsChange newNotifications

  _getTolerance: ->
    notifications = @_getNotificationsForChannel('processing').filter (notification) ->
      notification.hasIn(['parameters', 'tolerance'])

    if !notifications.count()
      20
    else
      notifications.first().getIn(['parameters', 'tolerance'])

  _getNotificationsForChannel: (channelName) ->
    @props.notifications.filter (notification) ->
      notification.get('channel') == channelName
