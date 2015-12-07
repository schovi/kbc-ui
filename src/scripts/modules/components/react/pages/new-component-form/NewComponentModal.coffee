React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'
ComponentsStore = require '../../../stores/ComponentsStore'
NewConfigurationsStore = require '../../../stores/NewConfigurationsStore'

NewConfigurationsActionCreators = require '../../../NewConfigurationsActionCreators'

DefaultForm = require './DefaultForm'
GoodDataWriterForm = require './GoodDataWriterForm'
ManualConfigurationForm = require './ManualConfigurationFrom'

hiddenComponents = require '../../../../components/utils/hiddenComponents'

{div} = React.DOM

ModalHeader = React.createFactory(require('react-bootstrap/lib/ModalHeader'))
ModalBody = React.createFactory(require('react-bootstrap/lib/ModalBody'))
ModalFooter = React.createFactory(require('react-bootstrap/lib/ModalFooter'))
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

module.exports = React.createClass
  displayName: 'NewComponentModal'
  mixins: [createStoreMixin(NewConfigurationsStore)]

  propTypes:
    component: React.PropTypes.object.isRequired
    onClose: React.PropTypes.func.isRequired

  getStateFromStores: ->
    componentId = @props.component.get('id')
    configuration: NewConfigurationsStore.getConfiguration(componentId)
    isValid: NewConfigurationsStore.isValidConfiguration(componentId)
    isSaving: NewConfigurationsStore.isSavingConfiguration(componentId)

  _handleReset: ->
    NewConfigurationsActionCreators.resetConfiguration(@props.component.get 'id')
    @props.onClose()

  _handleChange: (newConfiguration) ->
    NewConfigurationsActionCreators.updateConfiguration(@props.component.get('id'), newConfiguration)

  _handleSave: ->
    NewConfigurationsActionCreators.saveConfiguration(@props.component.get('id'))

  render: ->
    React.createElement @_getFormHandler(),
      component: @props.component
      configuration: @state.configuration
      isValid: @state.isValid
      isSaving: @state.isSaving
      onCancel: @_handleReset
      onChange: @_handleChange
      onSave: @_handleSave
      onClose: @props.onClose

  _getFormHandler: ->
    hasUI = @props.component.get('hasUI') or
      hiddenComponents.hasDevelPreview(@props.component.get('id')) or
      @props.component.get('flags').includes('genericUI') or
      @props.component.get('flags').includes('genericDockerUI')

    if !hasUI
      return ManualConfigurationForm

    switch @props.component.get('id')
      when 'gooddata-writer' then GoodDataWriterForm
      else DefaultForm


