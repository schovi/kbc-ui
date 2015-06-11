React = require 'react'
Immutable = require 'immutable'

api = require '../../../api'

{Loader} = require 'kbc-react-components'
Graph = require './Graph'

PureRenderMixin = require('react/addons').addons.PureRenderMixin

module.exports = React.createClass
  displayName: 'GraphContainer'
  mixins: [PureRenderMixin]
  propTypes:
    configurationId: React.PropTypes.string.isRequired

  componentDidMount: ->
    api
    .getWriterModel @props.configurationId
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

  getInitialState: ->
    isLoading: true
    model: null

  render: ->
    React.DOM.div className: 'kb-graph',
      if @state.isLoading
        React.DOM.div className: 'well',
          React.createElement Loader
      else if !@state.model.get('nodes').count()
        React.DOM.div className: 'well',
          'No datasets defined.'
      else
        React.createElement Graph,
          model: @state.model
