React = require 'react'
date = require '../../../utils/date.coffee'

{table, thead, tbody, tr, th, td} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  render: ->
    tr null,
      td null,
        date.format @props.event.get('created'),
      td null,
        @props.event.get('message')