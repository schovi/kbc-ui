React = require 'react'
createStoreMixin = require('../../../../react/mixins/createStoreMixin')
JobsStore = require('../../stores/OrchestrationJobsStore')
ActionCreators = require('../../ActionCreators')
RoutesStore = require('../../../../stores/RoutesStore')
TaskSelectTable = React.createFactory(require './TaskSelectTable')
Confirm = React.createFactory(require '../../../../react/common/Confirm')
TasksTable = React.createFactory(require('../pages/orchestration-tasks/TasksTable'))
TasksTableRow = React.createFactory(require('../pages/orchestration-tasks/TasksTableRow'))
ComponentsStore = require '../../../components/stores/ComponentsStore'
JobActionCreators = require '../../ActionCreators'
OrchestrationJobStore = require ('../../stores/OrchestrationJobsStore')

TaskSelectModal = React.createFactory(require('../modals/TaskSelect'))
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)

{ComponentIcon, ComponentName} = require '../../../../react/common/common'
{Tree, Check} = require 'kbc-react-components'
Loader = React.createFactory(require('kbc-react-components').Loader)

{table, thead, tbody, th, td, tr, input, button, span} = React.DOM

module.exports = React.createClass
  displayName: 'JobRetryButton'
  mixins: [createStoreMixin(JobsStore)]
  propTypes:
    job: React.PropTypes.object.isRequired
    isSaving: React.PropTypes.bool.isRequired
    notify: React.PropTypes.bool

  getDefaultProps: ->
    tooltipPlacement: 'top'

  _getJobId: ->
    RoutesStore.getCurrentRouteIntParam 'jobId'

  getInitialState: ->
    components: ComponentsStore.getAll()
    isSaving: false

  getStateFromStores: ->
    jobId = @_getJobId()
    job: JobsStore.getJob jobId

  _handleRun: ->
    ActionCreators.retryOrchestrationJob(
      @state.job.get('id')
      @state.job.get('orchestrationId')
      @props.notify
    )

  _canBeRetried: ->
    status = @state.job.get('status')
    status is 'success' ||
      status is 'error' ||
      status is 'cancelled' ||
      status is 'canceled' ||
      status is 'terminated' ||
        status is 'warning' ||
          status is 'warn'

  render: ->
    tasks = @state.job.get('tasks')
    if @_canBeRetried() && tasks
      ModalTrigger
        modal: TaskSelectModal
          job: @props.job
          tasks: OrchestrationJobStore.getEditingValue @props.job.get('id'), 'tasks'
          onChange: @_handleTaskChange
          onRun: @_handleRun
      ,
        button
          onClick: @_handleRetrySelectStart
          className: 'btn btn-link'
        ,
          if @props.isSaving
            Loader()
          else
            span
              className: 'fa fa-fw fa-play'
          ' Job retry'
    else
      null

  _handleRetrySelectStart: ->
    JobActionCreators.startJobRetryTasksEdit(@state.job.get('id'))

  _handleTaskChange: (updatedTask) ->
    tasks = OrchestrationJobStore.getEditingValue @props.job.get('id'), 'tasks'
    index = tasks.findIndex((task) -> task.get('id') == updatedTask.get('id'))

    JobActionCreators.updateJobRetryTasksEdit(
      @props.job.get('id')
      tasks.set(index, tasks.get(index).set('active', updatedTask.get('active')))
    )