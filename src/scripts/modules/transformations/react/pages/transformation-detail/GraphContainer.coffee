React = require 'react'
Immutable = require 'immutable'

api = require '../../../TransformationsApi.coffee'

{Loader} = require 'kbc-react-components'
Graph = React.createFactory (require './Graph')
TransformationsStore  = require('../../../stores/TransformationsStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsActionCreators = require '../../../ActionCreators'
immutableMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

module.exports = React.createClass
  displayName: 'GraphContainer'
  mixins: [createStoreMixin(TransformationsStore), immutableMixin]

  propTypes:
    bucketId: React.PropTypes.string.isRequired
    transformationId: React.PropTypes.string.isRequired
    disabled: React.PropTypes.bool.isRequired

  getStateFromStores: ->
    showDisabled: TransformationsStore.isShowDisabledInOverview(@props.bucketId, @props.transformationId)
    isLoading: TransformationsStore.isOverviewLoading(@props.bucketId, @props.transformationId)
    model: TransformationsStore.getOverview(@props.bucketId, @props.transformationId)

  componentDidMount: ->
    @_loadData()

  _loadData: ->
    TransformationsActionCreators.loadTransformationOverview(
      @props.bucketId, @props.transformationId, @state.showDisabled
    )

  _handleChangeShowDisabled: (val) ->
    TransformationsActionCreators.showTransformationOverviewDisabled(@props.bucketId, @props.transformationId, val)

  render: ->
    React.DOM.div className: 'kb-graph',
      if @state.isLoading
        React.DOM.div className: 'row text-center',
          React.createElement Loader
      else if !@state.model || !@state.model.get('nodes').count()
        React.DOM.div className: 'row text-center',
          'No nodes found.'
      else
        Graph
          model: @state.model
          centerNodeId: @props.bucketId + "." + @props.transformationId
          disabledTransformation: @props.disabled
          showDisabled: @state.showDisabled
          showDisabledHandler: @_handleChangeShowDisabled
