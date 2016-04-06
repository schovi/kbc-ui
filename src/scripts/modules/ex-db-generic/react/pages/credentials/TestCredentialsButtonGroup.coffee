React = require 'react'
classnames = require 'classnames'
Button = React.createFactory(require('react-bootstrap').Button)

Loader = React.createFactory(require('kbc-react-components').Loader)
Link = React.createFactory(require('react-router').Link)

{div, span} = React.DOM

actionsProvisioning = require '../../../actionsProvisioning'
# THIS REACT COMPONENT IS NOT USED!!! SEE render method!
module.exports = React.createClass
  displayName: 'TestCredentialsButtonGroup'
  propTypes:
    credentials: React.PropTypes.object.isRequired
    hasOffset: React.PropTypes.bool.isRequired
    componentId: React.PropTypes.string.isRequired

  getDefaultProps: ->
    hasOffset: true

  getInitialState: ->
    isTesting: false
    job: null

  _startTesting: ->
    ExDbActionCreators = actionsProvisioning.createActions(@props.componentId)
    @setState
      isTesting: true
      job: null

    ExDbActionCreators
    .testCredentials @props.credentials
    .then @_onTestingDone

  _onTestingDone: (job) ->
    @setState
      isTesting: false
      job: job

  render: ->
    return null #TODO: remove when the backend has the test credentials feature

    div className: 'form-group',
      div className: classnames('col-xs-8', 'col-xs-offset-4': @props.hasOffset),
        Button
          bsStyle: 'primary'
          disabled: @state.isTesting
          onClick: @_startTesting
        ,
          'Test Credentials'
        ' '
        Loader() if @state.isTesting
        if @state.job
          if @state.job.status == 'success'
            @_testSuccess @state.job
          else
            @_testError @state.job

  _testSuccess: (job) ->
    span className: 'text-success',
      span className: 'fa fa-fw fa-check'
      ' Connected! '
      Link
        to: 'jobDetail'
        params:
          jobId: job.id
      ,
        'details'

  _testError: (job) ->
    span className: 'text-danger',
      span className: 'fa fa-fw fa-meh-o'
      ' Failed to connect! '
      Link
        to: 'jobDetail'
        params:
          jobId: job.id
      ,
        'details'
