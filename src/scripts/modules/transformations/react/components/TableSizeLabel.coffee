React = require 'react'
FileSize = React.createFactory(require '../../../../react/common/FileSize')

{span} = React.DOM

TableSizeLabel = React.createClass
  displayName: 'TableSizeLabel'
  propTypes:
    size: React.PropTypes.number

  render: ->
    span {className: 'label label-primary'},
      FileSize {size: @props.size}

module.exports = TableSizeLabel
