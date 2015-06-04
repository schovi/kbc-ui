React = require 'react'
pureRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

TableRow = React.createFactory(require './TableRow')
{div, span, strong} = React.DOM

module.exports = React.createClass
  displayName: 'BucketTablesList'
  mixin: [pureRendererMixin]
  propTypes:
    tables: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    childs = @props.tables.map((table) ->
      TableRow
        table: table
        configId: @props.configId
        key: table.get 'id'
    , @).toArray()

    div className: 'row',
      div className: 'table table-striped table-hover',
        div className: 'thead', key: 'table-header',
          div className: 'tr',
            span className: 'th',
              strong null, 'Table name'
            span className: 'th',
              strong null, 'Good Data name'
            span className: 'th'
        div className: 'tbody',
          childs
