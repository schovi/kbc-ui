React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

Link = React.createFactory(require('react-router').Link)
Check = React.createFactory(require('../../../../../react/common/common').Check)
QueryDeleteButton = React.createFactory(require('../../components/QueryDeleteButton'))
RunExtractionButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')

actionCreators = require '../../../exDbActionCreators'

{span, div, a, button, i} = React.DOM

module.exports = React.createClass
  displayName: 'QueryRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    query: React.PropTypes.object.isRequired
    pendingActions: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  _handleActiveChange: (newValue) ->
    actionCreators.changeQueryEnabledState(@props.configurationId, @props.query.get('id'), newValue)

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
        if @props.query.get 'name'
          @props.query.get 'name'
        else
          span className: 'text-muted',
            'Untitled'
      span className: 'td',
        @props.query.get 'outputTable'
      span className: 'td',
        Check isChecked: @props.query.get 'incremental'
      span className: 'td',
        @props.query.get 'primaryKey'
      span className: 'td text-right',
        QueryDeleteButton
          query: @props.query
          configurationId: @props.configurationId
          isPending: @props.pendingActions.has 'deleteQuery'
        ActivateDeactivateButton
          activateTooltip: 'Enable Query'
          deactivateTooltip: 'Disable Query'
          isActive: @props.query.get('enabled')
          isPending: @props.pendingActions.has 'enabled'
          onChange: @_handleActiveChange
        RunExtractionButton
          title: 'Run Extraction'
          component: 'ex-db'
          runParams: ->
            query: props.query.get 'id'
            config: props.configurationId
        ,
          'You are about to run extraction.'
