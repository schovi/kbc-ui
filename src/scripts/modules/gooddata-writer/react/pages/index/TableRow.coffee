React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Link = React.createFactory(require('react-router').Link)

{span, div, a, button, i} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    Link
      className: 'tr'
      to: 'gooddata-writer-table'
      params:
        config: @props.configId
        table: @props.table.get 'id'
    ,
      span className: 'td',
        @props.table.get 'id'
      span className: 'td',
        @props.table.get 'name'
      span className: 'td text-right',
        'todo'