React = require 'react'
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon').default)
ComponentName = React.createFactory(require('../../../../../react/common/ComponentName').default)

{div, h2, a, i, span} = React.DOM

require './ConfigurationSelect.less'

OrchestrationSelect = React.createClass
  displayName: 'OrchestrationSelect'
  propTypes:
    component: React.PropTypes.object.isRequired
    orchestrations: React.PropTypes.object.isRequired
    onReset: React.PropTypes.func.isRequired
    onConfigurationSelect: React.PropTypes.func.isRequired

  render: ->
    orchestrations = @props.orchestrations

    div null,
      div className: 'table configuration-select-header',
        div className: 'tr',
          div className: 'td',
            h2 null,
              ComponentIcon component: @props.component
              ' '
              ComponentName component: @props.component
          div className: 'td',
            a className: 'pull-right', onClick: @_handleBack,
              span className: 'fa fa-chevron-left', null
              ' Back'
      div className: 'list-group',
        orchestrations
        .map((configuration) ->
          a
            className: 'list-group-item'
            key: configuration.get('id')
            onClick: @_handleSelect.bind(@, configuration)
          ,
            configuration.get('name')
            i className: 'fa fa-plus-circle pull-right'
        , @).toArray()

  _handleBack: ->
    @props.onReset()

  _handleSelect: (configuration) ->
    @props.onConfigurationSelect(configuration)


module.exports = OrchestrationSelect
