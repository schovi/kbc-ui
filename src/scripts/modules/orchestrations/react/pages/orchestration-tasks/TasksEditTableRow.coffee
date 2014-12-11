React = require 'react'
common = require '../../../../../react/common/common.coffee'

ComponentIcon = React.createFactory(common.ComponentIcon)
ComponentName = React.createFactory(common.ComponentName)
Tree = React.createFactory(common.Tree)
Check = React.createFactory(common.Check)

{tr, td, span} = React.DOM

TasksEditTableRow = React.createClass
  displayName: 'TasksEditTableRow'
  propTypes:
    task: React.PropTypes.object.isRequired
    component: React.PropTypes.object
  render: ->
    tr null,
      td null,
        if @props.component
          ComponentIcon component: @props.component
        else
          ' '
      td null,
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


module.exports = TasksEditTableRow

