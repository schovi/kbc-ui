React = require 'react'
moment = require 'moment'

{span, i} = React.DOM

FinishedWithIcon = React.createClass
  displayName: 'FinishedWithIcon'
  propTypes:
    endTime: React.PropTypes.string
  render: ->
    span {},
      i {className: 'fa fa-calendar', title: 'Finished'}
      ' '
      moment(@props.endTime).fromNow()


module.exports = FinishedWithIcon