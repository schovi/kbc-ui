React = require 'react'

Confirm = require './Confirm'
{Loader} = require 'kbc-react-components'

{button, span} = React.DOM

module.exports = React.createClass
  displayName: 'JobTerminateButton'
  props:
    job: React.PropTypes.object.isRequired
    isTerminating: React.PropTypes.bool.isRequired
    onTerminate: React.PropTypes.func.isRequired

  render: ->
    if @props.job.get('status') == 'waiting' || @props.job.get('status') == 'processing'
      React.DOM.div null,
        React.createElement(Loader) if @props.isTerminating
        ' '
        React.createElement Confirm,
          title: 'Terminate Job'
          text: "Do you really want to terminate the job #{@props.job.get('id')}?"
          buttonLabel: 'Terminate'
          onConfirm: @props.onTerminate
        ,
          button
            className: 'btn btn-link'
            disabled: @props.isTerminating
          ,
            span className: 'fa fa-fw fa-times'
            'Terminate Job'
    else
      null
