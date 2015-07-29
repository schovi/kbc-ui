React = require 'react'
TableRow = React.createFactory(require './EventsTableRow')
{Loader} = require('kbc-react-components')
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin'

{div} = React.DOM

module.exports = React.createClass
  displayName: 'EventsTable'
  mixins: [PureRendererMixin]
  propTypes:
    events: React.PropTypes.object.isRequired
    link: React.PropTypes.object.isRequired
    isLoading: React.PropTypes.bool.isRequired

  render: ->
    div className: 'table table-striped table-hover',
      div className: 'thead',
        div className: 'tr',
          div className: 'th',
            'Created'
          div className: 'th',
            'Event'
            ' '
            (React.createElement(Loader) if @props.isLoading)
      div className: 'tbody',
        @props.events.map( (event) ->
          TableRow
            onClick: @_handleEventSelect.bind(@, event)
            event: event
            link: @props.link
            key: event.get('id')
        , @).toArray()

  _handleEventSelect: (selectedEvent) ->
    @props.onEventSelect(selectedEvent)

