React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

ComponentSelect = React.createFactory(require './ComponentSelect.coffee')
ConfigurationSelect = React.createFactory(require './ConfigurationSelect.coffee')


InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore.coffee'

STEP_COMPONENT_SELECT = 'componentSelect'
STEP_CONFIGURATION_SELECT = 'configurationSelect'

{div, p, strong, h2, a} = React.DOM

AddTaskModal = React.createClass
  displayName: 'AddTaskModal'
  propTypes:
    onConfigurationSelect: React.PropTypes.func.isRequired

  getInitialState: ->
    components: InstalledComponentsStore.getAll()
    selectedComponent: null
    currentStep: STEP_COMPONENT_SELECT

  render: ->
    Modal title: "Add Task", onRequestHide: @props.onRequestHide,

      div className: 'modal-body',
        switch @state.currentStep

          when STEP_COMPONENT_SELECT
            ComponentSelect
              components: @state.components
              onComponentSelect: @_handleComponentSelect

          when STEP_CONFIGURATION_SELECT
            ConfigurationSelect
              component: @state.selectedComponent
              onReset: @_handleComponentReset
              onConfigurationSelect: @_handleConfigurationSelect

      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary',
            'Run'

  _handleComponentSelect: (component) ->
    @setState
      selectedComponent: component
      currentStep: STEP_CONFIGURATION_SELECT

  _handleComponentReset: ->
    @setState
      selectedComponent: null
      currentStep: STEP_COMPONENT_SELECT

  ###
    Configuration is selected
    close modal with selected configuration
  ###
  _handleConfigurationSelect: (configuration) ->
    @props.onRequestHide() # hide modal
    @props.onConfigurationSelect(@state.selectedComponent, configuration)




module.exports = AddTaskModal