React = require 'react'
Immutable = require 'immutable'

api = require '../../../TransformationsApi.coffee'

Loader = require '../../../../../react/common/Loader'
Graph = React.createFactory (require './Graph')

PureRenderMixin = require('react/addons').addons.PureRenderMixin

module.exports = React.createClass
  displayName: 'GraphContainer'
  mixins: [PureRenderMixin]

  propTypes:
    transformation: React.PropTypes.object.isRequired

  getInitialState: ->
    isLoading: true
    model: null
    showDisabled: if @props.transformation.get('disabled') == "1" then true else false
    disabledTransformation: if @props.transformation.get('disabled') == "1" then true else false

  componentDidMount: ->
    @_loadData()

  _loadData: ->
    tableId = @props.transformation.get 'fullId'
    api
    .getGraph
      tableId: tableId
      direction: 'around'
      showDisabled: @state.showDisabled
      limit: {sys: [tableId.substring(0, tableId.lastIndexOf("."))]}
    .then @_handleDataReceive
    .catch @_handleReceiveError

  _handleReceiveError: (e) ->
    @setState
      isLoading: false
    throw e

  _handleDataReceive: (model) ->
    @setState
      isLoading: false
      model: Immutable.fromJS model

  _handleChangeShowDisabled: (val) ->
    @setState
      isLoading: true
      showDisabled: val
    ,
      ->
        @_loadData()

  render: ->
    React.DOM.div className: 'kb-graph',
      if @state.isLoading
        React.DOM.div className: 'well',
          React.createElement Loader
      else if !@state.model.get('nodes').count()
        React.DOM.div className: 'well',
          'No datasets defined.'
      else
        Graph
          model: @state.model
          centerNodeId: @props.transformation.get 'fullId'
          disabledTransformation: @state.disabledTransformation
          showDisabled: @state.showDisabled
          showDisabledHandler: @_handleChangeShowDisabled
