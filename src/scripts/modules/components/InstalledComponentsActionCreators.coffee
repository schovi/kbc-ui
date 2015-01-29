Promise = require 'bluebird'
React = require 'react'
_ = require 'underscore'
Link = require('react-router').Link
console.log 'Link', Link


ApplicationActionCreators = require '../../actions/ApplicationActionCreators.coffee'

dispatcher = require '../../Dispatcher.coffee'
constants = require './Constants.coffee'
componentRunner = require './ComponentRunner.coffee'
InstalledComponentsStore = require './stores/InstalledComponentsStore.coffee'
installedComponentsApi = require './InstalledComponentsApi.coffee'

Pokus = React.createClass
  render: ->
    React.DOM.strong null, 'pokus'

module.exports =

  loadComponentsForce: ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD
    )

    installedComponentsApi
    .getComponents()
    .then((components) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
        components: components
      )
    )
    .catch((error) ->
      dispatcher.handleViewAction(
        type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_ERROR
        status: error.status
        response: error.response
      )
    )

  loadComponents: ->
    return Promise.resolve() if InstalledComponentsStore.getIsLoaded()
    @loadComponentsForce()

  receiveAllComponents: (componentsRaw) ->
    dispatcher.handleViewAction(
      type: constants.ActionTypes.INSTALLED_COMPONENTS_LOAD_SUCCESS
      components: componentsRaw
    )

  updateComponentConfiguration: (componentId, configurationId, data) ->
    dispatcher.handleViewAction
      type: constants.ActionTypes.INSTALLED_COMPONENTS_UPDATE_CONFIGURATION
      componentId: componentId
      configurationId: configurationId
      data: data

    installedComponentsApi
    .updateComponentConfiguration componentId, configurationId, data
    .then (response) ->
      console.log 'saved', response

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