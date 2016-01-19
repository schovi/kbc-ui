React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

ComponentSelect = React.createFactory(require './ComponentSelect')
ConfigurationSelect = React.createFactory(require './ConfigurationSelect')
ComponentsReloaderButton = require '../../../../components/react/components/ComponentsReloaderButton'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'

STEP_COMPONENT_SELECT = 'componentSelect'
STEP_CONFIGURATION_SELECT = 'configurationSelect'

{div, p, strong, h2, a} = React.DOM

AddTaskModal = React.createClass
  displayName: 'AddTaskModal'
  mixins: [createStoreMixin(InstalledComponentsStore)]
  propTypes:
    onConfigurationSelect: React.PropTypes.func.isRequired

  getInitialState: ->
    selectedComponent: null
    currentStep: STEP_COMPONENT_SELECT

  getStateFromStores: ->
    components = InstalledComponentsStore.getAll().filter (c) ->
      not c.get('flags').includes('excludeRun')
    components: components

  render: ->
    Modal title: @_modalTitle(), onRequestHide: @props.onRequestHide,

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
          Button
            bsStyle: 'link'
            onClick: @props.onRequestHide
          ,
            'Cancel'

  _modalTitle: ->
    React.DOM.h4 className: 'modal-title',
      "Add task "
      React.createElement ComponentsReloaderButton

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
