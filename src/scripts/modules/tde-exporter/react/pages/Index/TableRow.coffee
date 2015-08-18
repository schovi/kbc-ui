React = require 'react'

Link = React.createFactory(require('react-router').Link)

{button, i, strong, span, div, p, ul, li} = React.DOM

module.exports = React.createClass
  displayName: 'tablerowtde'

  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    Link
      className: 'tr'
      to: "tde-exporter-table"
      params:
        config: @props.configId
        tableId: @props.table.get('id')
      span className: 'td',
        @props.table.get 'name'
      span className: 'td',
        'last tde file TODO'
