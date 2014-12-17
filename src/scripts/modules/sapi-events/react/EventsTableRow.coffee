React = require 'react'
date = require '../../../utils/date.coffee'
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin.coffee'
sapiEventsUtils = require '../utils.coffee'

{table, thead, tbody, tr, th, td} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  mixins: [PureRendererMixin]
  render: ->
    tr
      className: sapiEventsUtils.classForEventType(@props.event.get('type'))
      onClick: @props.onClick,
    ,
      td null,
        date.format @props.event.get('created'),
      td null,
        @props.event.get('message')