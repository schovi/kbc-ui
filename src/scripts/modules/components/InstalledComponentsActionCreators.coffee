Promise = require 'bluebird'
React = require 'react'
_ = require 'underscore'
Link = require('react-router').Link

ApplicationActionCreators = require '../../actions/ApplicationActionCreators'
JobsActionCreators = require '../../modules/jobs/ActionCreators'

dispatcher = require '../../Dispatcher'
constants = require './Constants'
componentRunner = require './ComponentRunner'
InstalledComponentsStore = require './stores/InstalledComponentsStore'
installedComponentsApi = require './InstalledComponentsApi'
RoutesStore = require '../../stores/RoutesStore'
ComponentsStore = require './stores/ComponentsStore'

deleteComponentConfiguration = require './utils/deleteComponentConfiguration'


module.exports =


  loadComponentsForce: ->
    dispatcher.handleAsyncAction constants.ActionTypes.INSTALLED_COMPONENTS_LOAD,
      installedComponentsApi
      .getComponents()

  loadComponents: ->
    return Promise.resolve() if InstalledComponentsStore.getIsLoaded()
    @loadComponentsForce()

  receiveAllComponents: (componentsRaw) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD
      data: componentsRaw
    )

  startConfigurationEdit: (componentId, configurationId, field) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_CONFIGURATION_EDIT_START
      componentId: componentId
      configurationId: configurationId
      field: field

  updateEditingConfiguration: (componentId, configurationId, field, newValue) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_CONFIGURATION_EDIT_UPDATE
      configurationId: configurationId
      componentId: componentId
      field: field
      value: newValue

  cancelConfigurationEdit: (componentId, configurationId, field) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_CONFIGURATION_EDIT_CANCEL
      componentId: componentId
      configurationId: configurationId
      field: field

  saveConfigurationEdit: (componentId, configurationId, field) ->
    newValue = InstalledComponentsStore.getEditingConfig(componentId, configurationId, field)

    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION_START
      componentId: componentId
      configurationId: configurationId
      field: field

    data = {}
    data[field] = newValue

    installedComponentsApi
    .updateComponentConfiguration componentId, configurationId, data
    .then (response) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION_SUCCESS
        componentId: componentId
        configurationId: configurationId
        field: field
        data: response
    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION_ERROR
        componentId: componentId
        configurationId: configurationId
        field: field
        error: e
      throw e


  deleteConfiguration: (componentId, configurationId) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_DELETE_CONFIGURATION_START
      componentId: componentId
      configurationId: configurationId

    component = ComponentsStore.getComponent componentId
    configuration = InstalledComponentsStore.getConfig componentId, configurationId
    transitionTo = "#{component.get('type')}s"

    notification = "Configuration #{configuration.get('name')} was deleted."

    deleteComponentConfiguration componentId, configurationId
    .then (response) ->
      RoutesStore.getRouter().transitionTo transitionTo

      setTimeout ->
        dispatcher.handleViewAction
          type: constants.ActionTypes.INSTALLED_COMPONENTS_DELETE_CONFIGURATION_SUCCESS
          componentId: componentId
          configurationId: configurationId

      ApplicationActionCreators.sendNotification notification

    .catch (e) ->
      dispatcher.handleViewAction
        type: constants.ActionTypes.INSTALLED_COMPONENTS_DELETE_CONFIGURATION_ERROR
        componentId: componentId
        configurationId: configurationId
        error: e

      throw e


  ###
    params:
      - component - id of component like ex-db
      - data - action parameters hashmap
      - method - default = run
      - message - enqueue message
  ###
  runComponent: (params) ->

    defaultParams =
      method: 'run'
      message: 'Extractor job has been scheduled.'

    params = _.extend {}, defaultParams, params

    componentRunner.run
      component: params.component
      data: params.data
      method: params.method
    .then (job) ->
      JobsActionCreators.recieveJobDetail(job)
      ApplicationActionCreators.sendNotification(React.createClass
        render: ->
          React.DOM.span null,
            "#{params.message} You can track the job progress "
            React.createElement Link,
              to: 'jobDetail'
              params:
                jobId: job.id
              onClick: @props.onClick
            ,
              'here'
      )
