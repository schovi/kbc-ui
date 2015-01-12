React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'

Link = React.createFactory(require('react-router').Link)
Check = React.createFactory(require('../../../../../react/common/common.coffee').Check)

{span, div, a, button, i} = React.DOM


module.exports = React.createClass(
  displayName: 'QueryRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    query: React.PropTypes.object
    configurationId: React.PropTypes.string

  render: ->
    Link
      className: 'tr'
      to: 'ex-db-query'
      params:
        config: @props.configurationId
        query: @props.query.get 'id'
    ,
      span className: 'td',
        @props.query.get 'outputTable'
      span className: 'td',
        Check isChecked: @props.query.get 'incremental'
      span className: 'td',
        @props.query.get 'primaryKey'
      span className: 'td'

)
