React = require 'react'

OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Popover = React.createFactory(require('react-bootstrap').Popover)
PureRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

{span, ul, li} = React.DOM



module.exports = React.createClass
  displayName: 'DateFormatHint'
  mixins: [PureRenderMixin]
  render: ->
    OverlayTrigger
      overlay: @_renderPopover()
    ,
      span  className: 'fa fa-question-circle'

  _renderPopover: ->
    Popover
      title: 'Supported Date Formats'
    ,
      ul null,
        li null, 'yyyy – year (e.g. 2010)'
        li null, 'MM – month (01 - 12)'
        li null, 'dd – day (01 - 31)'
        li null, 'hh – hour (01 - 12)'
        li null, 'HH – hour 24 format (00 - 23)'
        li null, 'mm – minutes (00 - 59)'
        li null, 'ss – seconds (00 - 59)'
        li null, 'kk/kkkk – microseconds or fractions of seconds (00-99, 000-999, 0000-9999)'
        li null, 'GOODDATA - number of days since 1900-01-01'
