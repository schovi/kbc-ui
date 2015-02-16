React = require 'react'
date = require '../../../utils/date'
filesize = require('../../../utils/utils').filesize
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin'


sapiEventsUtils = require '../utils'
Tree = React.createFactory(require('../../../react/common/common').Tree)
{div, span, a, h2, h3, p, ul, li} = React.DOM


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
      @_attachments()
      @_treeSection('Parameters', 'params')
      @_treeSection('Results', 'results')
      @_treeSection('Performance', 'performance')
      @_treeSection('Context', 'context')

  _attachments: ->
    return null if !@props.event.get('attachments').size
    div null,
      h3 null,
        'Attachments'
      ul null,
        @props.event.get('attachments').map((attachment) ->
          li null,
            a
              href: attachment.get('url')
            ,
              attachment.get('name')
              " (#{filesize attachment.get('sizeBytes')}) "
        ).toArray()

  _treeSection: (header, eventPropertyName) ->
    return null if !@props.event.get(eventPropertyName)?.size
    div null,
      h3 null,
        header,
      Tree data: @props.event.get(eventPropertyName)


  _eventClass: ->
    sapiEventsUtils.classForEventType(@props.event.get('type'))