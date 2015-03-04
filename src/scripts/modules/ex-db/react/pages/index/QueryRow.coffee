React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

Link = React.createFactory(require('react-router').Link)
Loader = React.createFactory(require '../../../../../react/common/Loader')
Check = React.createFactory(require('../../../../../react/common/common').Check)
QueryDeleteButton = React.createFactory(require('../../components/QueryDeleteButton'))
RunExtractionButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')

{span, div, a, button, i} = React.DOM

module.exports = React.createClass
  displayName: 'QueryRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    query: React.PropTypes.object.isRequired
    isDeleting: React.PropTypes.bool.isRequired
    configurationId: React.PropTypes.string.isRequired

  render: ->
    props = @props
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
        RunExtractionButton
          title: 'Run Extraction'
          body: span {}, 'You are about to run extraction.'
          component: 'ex-db'
          runParams: ->
            query: props.query.get 'id'
            config: props.configurationId
