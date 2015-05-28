React = require 'react'
TableRow = React.createFactory(require './EventsTableRow')
{Loader} = require('kbc-react-components')
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin'

{table, thead, tbody, tr, th, td} = React.DOM

module.exports = React.createClass
  displayName: 'EventsTable'
  mixins: [PureRendererMixin]
  propTypes:
    events: React.PropTypes.object.isRequired
    onEventSelect: React.PropTypes.func.isRequired
    isLoading: React.PropTypes.bool.isRequired

  render: ->
    table className: 'table table-striped table-hover',
      thead null,
        tr null,
          th null, 'Created'
          th null,
            'Event'
            ' '
            (React.createElement(Loader) if @props.isLoading)
      tbody null,
        @props.events.map( (event) ->
          TableRow
            onClick: @_handleEventSelect.bind(@, event)
            event: event
            key: event.get('id')
        , @).toArray()

  _handleEventSelect: (selectedEvent) ->
    @props.onEventSelect(selectedEvent)

