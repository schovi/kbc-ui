React = require 'react'
{ComponentIcon, ComponentName} = require '../../../../../react/common/common'
{Tree, Check} = require 'kbc-react-components'

{tr, td, span} = React.DOM

module.exports = React.createClass
  displayName: 'TasksTableRow'
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
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
        React.createElement Check, isChecked: @props.task.get('active')
      td null,
        React.createElement Check, isChecked: @props.task.get('continueOnFailure')
