React = require 'react'
TableRow = React.createFactory(require './EventsTableRow.coffee')

{table, thead, tbody, tr, th, td} = React.DOM

module.exports = React.createClass
  displayName: 'EventsTable'
  propTypes:
    events: React.PropTypes.object.isRequired

  render: ->
    table className: 'table table-striped',
      thead null,
        tr null,
          th null, 'Created'
          th null, 'Event'
      tbody null,
        @props.events.map( (event) ->
          TableRow
            event: event
            key: event.get('id')
        , @).toArray()

