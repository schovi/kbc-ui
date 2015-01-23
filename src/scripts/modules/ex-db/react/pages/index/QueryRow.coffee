React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'

Link = React.createFactory(require('react-router').Link)
Loader = React.createFactory(require '../../../../../react/common/Loader.coffee')
Check = React.createFactory(require('../../../../../react/common/common.coffee').Check)
QueryDeleteButton = React.createFactory(require('../../components/QueryDeleteButton.coffee'))

{span, div, a, button, i} = React.DOM

module.exports = React.createClass
  displayName: 'QueryRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    query: React.PropTypes.object.isRequired
    isDeleting: React.PropTypes.bool.isRequired
    configurationId: React.PropTypes.string.isRequired

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
      span className: 'td text-right',
        if @props.isDeleting
          Loader()
        else
          QueryDeleteButton
            query: @props.query
            configurationId: @props.configurationId