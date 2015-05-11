React = require 'react'

{span, small} = React.DOM

ComponentName = React.createClass
  displayName: 'ComponentName'
  propTypes:
    component: React.PropTypes.object
  render: ->
    span null,
      @props.component.get('name'),
      ' ',
      small(null, @props.component.get('type')) if @canShowType()

  canShowType: ->
    @props.component.get('type') == 'extractor' || @props.component.get('type') == 'writer'

module.exports = ComponentName