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
        span className: (if @props.task.get('active')
          'kbc-icon-check-tick'
        else
          'kbc-icon-check-cross'),
          span className: 'path1'
          span className: 'path2'
          span className: 'path3'
      td null,
        span className: (if @props.task.get('continueOnFailure')
          'kbc-icon-check-tick'
        else 'kbc-icon-check-cross'),
          span className: 'path1'
          span className: 'path2'
          span className: 'path3'


module.exports = TasksTableRow

