React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'

WrDbActions = require '../../../actionCreators'

WrDbStore = require '../../../store'
RoutesStore = require '../../../../../stores/RoutesStore'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

{div} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
{Protected} = require 'kbc-react-components'

{form, div, label, p, option} = React.DOM

driver = 'mysql'

module.exports = React.createClass

  displayName: 'WrDbCredentials'

  mixins: [createStoreMixin(InstalledComponentsStore, WrDbStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    credentials = WrDbStore.getCredentials(driver, configId)
    isEditing = !! WrDbStore.getEditingByPath(driver, configId, 'creds')
    if isEditing
      credentials = WrDbStore.getEditingByPath(driver, configId, 'creds')
    isSaving = !! WrDbStore.getSavingCredentials(driver, configId)

    credentials: credentials
    configId: configId
    isEditing: isEditing
    isSaving: isSaving


  render: ->
    div {className: 'container-fluid kbc-main-content'},
      form className: 'form-horizontal',
        div className: 'row',
          @_createInput 'Host name', 'host'
          @_createInput 'Port', 'port', 'number'
          @_createInput 'Username', 'user'
          @_createInput 'Password', 'password', 'password', true
          @_createInput 'Database Name', 'database', 'text'

  _handleChange: (propName, event) ->
    if ['port', 'retries'].indexOf(propName) >= 0
      value = parseInt event.target.value
    else
      value = event.target.value
    creds = @state.credentials.set propName, value
    WrDbActions.setEditingData driver, @state.configId, 'creds', creds
    #@props.onChange(@state.credentials.set propName, value)

  _createInput: (labelValue, propName, type = 'text', isProtected = false) ->
    if @state.isEditing
      Input
        label: labelValue
        type: type
        value: @state.credentials.get propName
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
        onChange: @_handleChange.bind @, propName
    else if isProtected
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      ,
        React.createElement Protected, null,
          @state.credentials.get propName
    else
      StaticText
        label: labelValue
        labelClassName: 'col-xs-4'
        wrapperClassName: 'col-xs-8'
      , @state.credentials.get propName
