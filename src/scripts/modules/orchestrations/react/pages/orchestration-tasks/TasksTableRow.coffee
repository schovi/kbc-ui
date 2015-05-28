React = require 'react'
common = require '../../../../../react/common/common'

ComponentIcon = React.createFactory(common.ComponentIcon)
ComponentName = React.createFactory(common.ComponentName)
Tree = React.createFactory(require('kbc-react-components').Tree)
Check = React.createFactory(require('kbc-react-components').Check)

{tr, td, span} = React.DOM

TasksTableRow = React.createClass
  displayName: 'TasksTableRow'
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
  render: ->
    tr null,
      td null,
        span className: 'kbc-component-icon',
          if @props.component
            ComponentIcon component: @props.component
          else
            ' '

        if @props.component
          ComponentName component: @props.component
        else
          @props.task.get('componentUrl')
      td null,
        span className: 'label label-info',
          @props.task.get('action')
      td null,
        Tree data: @props.task.get('actionParameters')
      td null,
        Check isChecked: @props.task.get('active')
      td null,
        Check isChecked: @props.task.get('continueOnFailure')


module.exports = TasksTableRow

