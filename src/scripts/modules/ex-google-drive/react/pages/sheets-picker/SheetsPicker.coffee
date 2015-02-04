React = require('react')
ExGdriveStore = require '../../../exGdriveStore.coffee'
ActionCreators = require '../../../exGdriveActionCreators.coffee'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'
Accordion = React.createFactory(require('react-bootstrap').Accordion)
{div, span} = React.DOM

module.exports = React.createClass
  name: 'SheetsPicker'
  mixins: [createStoreMixin(ExGdriveStore)]
  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configId: configId
    files: ExGdriveStore.getGdriveFiles(configId)


  render: ->
    console.log 'sheet picker files', @state.files.toJS()
    div {className: 'container-fluid kbc-main-content'},
      @_renderGdriveFiles()
      @_renderProjectConfigFiles()

  _renderGdriveFiles: ->
    div classname: 'col-md-6',
      'gdrive files accordion HERE'
      # Accordion
      #   @state.files.map( (file) ->

      #   )


  _renderProjectConfigFiles: ->
    div classname: 'col-md-6',
      span {}, 'project config files'
