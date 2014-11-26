React = require 'react'


JobTasks = React.createClass
  displayName: 'JobTasks'
  propTypes:
    tasks: React.PropTypes.array.isRequired
  render: ->
    React.DOM.span null, 'tasks'


module.exports = JobTasks