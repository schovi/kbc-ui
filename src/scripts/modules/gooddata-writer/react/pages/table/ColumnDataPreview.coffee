React = require 'react'
Immutable = require 'immutable'
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Popover = React.createFactory(require('react-bootstrap').Popover)
PureRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

module.exports = React.createClass
  displayName: 'ColumnDataPreview'
  mixins: [PureRenderMixin]
  propTypes:
    columnName: React.PropTypes.string.isRequired
    tableData: React.PropTypes.array

  render: ->
    OverlayTrigger
      placement: 'left'
      overlay: @_renderPopover()
    ,
      React.DOM.button className: 'btn btn-link',
        React.DOM.span className: 'fa fa-eye'

  _renderPopover: ->
    Popover
      title: "Preview - #{@props.columnName}"
    ,
      if !@props.tableData
        'Loading data ...'
      else
        React.DOM.ul null,
          @_getColumnValues().map (value) ->
            React.DOM.li null, value
          .toArray()

  _getColumnValues: ->
    data = Immutable.fromJS(@props.tableData)
    columnIndex = data.first().indexOf @props.columnName

    data
    .shift()
    .map (row) ->
      row.get columnIndex
