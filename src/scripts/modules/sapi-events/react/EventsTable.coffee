React = require 'react'
TableRow = React.createFactory(require './EventsTableRow.coffee')
RefreshIcon = React.createFactory(require('../../../react/common/common.coffee').RefreshIcon)
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin.coffee'

{table, thead, tbody, tr, th, td} = React.DOM

module.exports = React.createClass
  displayName: 'EventsTable'
  mixins: [PureRendererMixin]
  propTypes:
    events: React.PropTypes.object.isRequired
    isLoading: React.PropTypes.bool.isRequired

  render: ->
    table className: 'table table-striped',
      thead null,
        tr null,
          th null, 'Created'
          th null,
            'Event'
            (RefreshIcon(isLoading: true) if @props.isLoading)
      tbody null,
        @props.events.map( (event) ->
          TableRow
            event: event
            key: event.get('id')
        , @).toArray()

