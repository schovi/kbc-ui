React = require 'react'
{tr, td, div, span} = React.DOM

module.exports = React.createClass
  displayName: "WrColumnRow"
  propTypes:
    column: React.PropTypes.object

  render: ->
    tr null,
      td null, @props.column.get('name')
      td null, @props.column.get('dbName')
      td null, @props.column.get('type')
