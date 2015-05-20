React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{Map} = require 'immutable'

QueryRow = React.createFactory(require './QueryRow')
Link = React.createFactory(require('react-router').Link)
QueryDeleteButton = React.createFactory(require('../../components/QueryDeleteButton'))

{span, div, a, strong} = React.DOM

module.exports = React.createClass
  displayName: 'QueryTable'
  mixins: [ImmutableRenderMixin]
  propTypes:
    configuration: React.PropTypes.object
    pendingActions: React.PropTypes.object

  render: ->
    childs = @props.configuration.get('queries').map((query) ->
      QueryRow
        query: query
        pendingActions: @props.pendingActions.get query.get('id'), Map()
        configurationId: @props.configuration.get 'id'
        key: query.get('id')
    , @).toArray()

    div className: 'table table-striped table-hover',
      div className: 'thead', key: 'table-header',
        div className: 'tr',
          span className: 'th',
            strong null, 'Name'
          span className: 'th',
            strong null, 'Output table'
          span className: 'th',
            strong null, 'Incremental'
          span className: 'th',
            strong null, 'Primary key'
          span className: 'th'
      div className: 'tbody',
        childs
