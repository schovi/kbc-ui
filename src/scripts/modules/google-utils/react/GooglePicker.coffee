React = require('react')
_ = require('underscore')
{Button} = require('react-bootstrap')
{div, span} = React.DOM
InitGoogleApis = require('./InitGoogleApis')
{apiKey, authorize, injectGapiScript} = InitGoogleApis
templates = require './PickerViewTemplates'
{GapiStore} = require './GapiFlux'
createStoreMixin = require '../../../react/mixins/createStoreMixin'

scope = 'https://www.googleapis.com/auth/drive.readonly'

setZIndex = ->
  elements = document.getElementsByClassName("picker")
  for el in elements
    el.style.zIndex = '1500'

authorizePicker = (userEmail, callbackFn) ->
  authorize(scope, callbackFn, userEmail)

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
  #picker.A.style.zIndex = 2000
  return picker


module.exports = React.createClass

  displayName: "googlePicker"
  mixins: [createStoreMixin(GapiStore)]
  propTypes:
    dialogTitle: React.PropTypes.string.isRequired
    buttonLabel: React.PropTypes.string.isRequired
    onPickedFn: React.PropTypes.func.isRequired
    views: React.PropTypes.array
    viewGroups: React.PropTypes.array
    email: React.PropTypes.string
    buttonProps: React.PropTypes.object

  getStateFromStores: ->
    isInitialized: GapiStore.isInitialized()

  componentDidMount: ->
    injectGapiScript()

  render: ->
    buttonProps =
      className: 'btn btn-success'
    if @props.buttonProps
      buttonProps = @props.buttonProps
    buttonProps['onClick'] = @_ButtonClick
    buttonProps['disabled'] = not @state.isInitialized

    React.createElement Button,
      buttonProps
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
    setZIndex()

  _onPicked: (data) ->
    if data.action != 'picked'
      return
    @props.onPickedFn(data.docs)
    return
