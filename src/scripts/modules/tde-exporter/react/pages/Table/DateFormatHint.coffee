React = require 'react'

OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Popover = React.createFactory(require('react-bootstrap').Popover)
PureRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

{span, ul, li, i} = React.DOM



module.exports = React.createClass
  displayName: 'DateFormatHint'
  mixins: [PureRenderMixin]
  render: ->
    OverlayTrigger
      bsSize: 'small'
      overlay: @_renderPopover()
    ,
      i  className: 'fa fa-question-circle'

  _renderPopover: ->
    Popover
      bsSize: 'small'
      title: 'Supported Date Formats'
    ,
      ul null,
        li null, '%Y – year (e.g. 2010)'
        li null, '%m – month (01 - 12)'
        li null, '%d – day (01 - 31)'
        li null, '%I – hour (01 - 12)'
        li null, '%H – hour 24 format (00 - 23)'
        li null, '%M – minutes (00 - 59)'
        li null, '%S – seconds (00 - 59)'
        li null, '%f – microsecond as a decimal number, zero-padded on the left.(000000, 000001, ..., 999999)'
