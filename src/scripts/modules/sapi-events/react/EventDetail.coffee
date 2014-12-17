React = require 'react'
date = require '../../../utils/date.coffee'
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin.coffee'

Tree = React.createFactory(require('../../../react/common/common.coffee').Tree)
{div, span, a, h2, h3, p} = React.DOM

_classMap =
  error: 'danger'
  warn: 'warning'
  success: 'success'

module.exports = React.createClass
  displayName: 'EventDetail'
  mixins: [PureRendererMixin]
  props:
    event: React.PropTypes.object.isRequired
    onGoBack: React.PropTypes.func.isRequired
  render: ->
    div null,
      a onClick: @props.onGoBack,
        span className: 'fa fa-chevron-left', null,
        ' back'
      h2 null,
        "Event #{@props.event.get('id')}"
      div className: "well message #{@_eventClass()}",
        @props.event.get('message')
      p className: 'well', @props.event.get('description') if @props.event.get('description')
      div className: 'row',
        div className: 'col-md-3',
          'Created'
        div className: 'col-md-9',
          date.format @props.event.get('created')
      div className: 'row',
        div className: 'col-md-3',
          'Component'
        div className: 'col-md-9',
          @props.event.get('component')
      div className: 'row',
        div className: 'col-md-3',
          'Configuration ID'
        div className: 'col-md-9',
          @props.event.get('configurationId') || 'N/A'
      div className: 'row',
        div className: 'col-md-3',
          'Run ID'
        div className: 'col-md-9',
          @props.event.get('runId')
       @_treeSection('Parameters', 'params')
       @_treeSection('Results', 'results')
       @_treeSection('Performance', 'performance')
       @_treeSection('Context', 'context')

  _treeSection: (header, eventPropertyName) ->
    return null if !@props.event.get(eventPropertyName)?.size

    div null,
      h3 null,
        header,
      Tree data: @props.event.get(eventPropertyName)


  _eventClass: ->
    _classMap[@props.event.get('type')]