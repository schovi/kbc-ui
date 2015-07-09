React = require('react')
_ = require('underscore')
{Button} = require('react-bootstrap')
{div, span} = React.DOM

templates = require './PickerViewTemplates'

apiUrl = 'https://apis.google.com/js/client.js?onload=handleGoogleClientLoad'
scope = 'https://www.googleapis.com/auth/drive.readonly'
clientId = '682649748090-hdan66m2vvudud332s99aud36fs15idj.apps.googleusercontent.com'
apiKey = 'AIzaSyBYjYUY81-DWMZBuNYRWOTSLt9NZqWG0cc'

window.handleGoogleClientLoad = ->
  console.log  "GAPI LOADED", window.gapi
  gapi.load('picker', -> )
  gapi.load('auth', -> )


injectGoogleApiScript = ->
  scripts = document.body.getElementsByTagName('script')
  apiScript = _.find scripts, (s) ->
    s.src == apiUrl
  if not apiScript and _.isUndefined(window.gapi)
    script = document.createElement('script')
    script.src = apiUrl
    document.body.appendChild script


authorizePicker = (userEmail, callbackFn) ->
  gapi.auth.authorize(
    'client_id': clientId
    'scope': scope
    'immediate': false
    'user_id': userEmail if userEmail
  , callbackFn)

createGdrivePicker = (views, viewGroups) ->
  picker = new google.picker.PickerBuilder()
    .setDeveloperKey(apiKey)
    .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
  #  .setOrigin($scope.origin)
  if _.isEmpty views
    views = [templates.root]

  for group in viewGroups
    picker = picker.addViewGroup(group())

  for view in views
    picker = picker.addView(view())

  return picker


module.exports = React.createClass

  displayName: "googlePicker"
  propTypes:
    dialogTitle: React.PropTypes.string.isRequired
    buttonLabel: React.PropTypes.string.isRequired
    onPickedFn: React.PropTypes.func.isRequired
    views: React.PropTypes.array
    viewGroups: React.PropTypes.array
    email: React.PropTypes.string

  componentDidMount: ->
    injectGoogleApiScript()

  render: ->
    React.createElement Button,
      onClick: @_ButtonClick
    ,
      @props.buttonLabel
  getDefaultProps: ->
    dialogTitle: 'Choose'
    buttonLabel: 'Choose'
    views: []
    onPickedFn: (data) ->
      console.log "picked", data

  getInitialState: ->
    accessToken: null

  _ButtonClick: ->
    if not @state.accessToken
      authorizePicker(@props.email, (authResult) =>
        if authResult and !authResult.error
          @setState
            accessToken: authResult.access_token
          @_doOpenGdrivePicker()
      )
    else #already authorized
      @_doOpenGdrivePicker()


  _doOpenGdrivePicker: ->
    picker = createGdrivePicker(@props.views, @props.viewGroups or [])
    picker = picker.setTitle(@props.dialogTitle)
      .setCallback(@_onPicked)
      .setOAuthToken(@state.accessToken)
    picker.build().setVisible(true)

  _onPicked: (data) ->
    if data.action != 'picked'
      return
    @props.onPickedFn(data.docs)
    return
