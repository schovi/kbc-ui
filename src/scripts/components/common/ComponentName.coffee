React = require 'react'

{span, small} = React.DOM

ComponentName = React.createClass(
  displayName: 'ComponentName'
  propTypes:
    component: React.PropTypes.object
  render: ->
   span null,
     @props.component.get('name'),
     ' ',
     small(null, @props.component.get('type')) if @props.component.get('type') != 'transformation'
)


module.exports = ComponentName