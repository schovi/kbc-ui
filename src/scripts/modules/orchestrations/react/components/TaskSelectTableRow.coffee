React = require 'react'

common = require('../../../../react/common/common')

createStoreMixin = require('../../../../react/mixins/createStoreMixin')
ComponentsStore = require '../../../components/stores/ComponentsStore'

ComponentIcon = common.ComponentIcon
ComponentName = common.ComponentName
{Tree, Check} = require 'kbc-react-components'

{span, input} = React.DOM
{table, thead, tbody} = React.DOM
{th, td, tr} = React.DOM

module.exports = React.createClass
  displayName: 'TaskSelectTableRow'
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
    onTaskUpdate: React.PropTypes.func.isRequired

  render: ->
    tr null,
      td null,
        span className: 'kbc-component-icon',
          if @props.component
            React.createElement ComponentIcon, component: @props.component
          else
            ' '
          if @props.component
            React.createElement ComponentName, component: @props.component
          else
            @props.task.get('componentUrl')
      td null,
        span className: 'label label-info',
          @props.task.get('action')
      td null,
        React.createElement Tree, data: @props.task.get('actionParameters')
      td null,
        input
          type: 'checkbox'
          disabled: false
          checked: @props.task.get('active')
          onChange: @_handleActiveChange


  _handleActiveChange: ->
    @props.onTaskUpdate @props.task.set('active', !@props.task.get('active'))