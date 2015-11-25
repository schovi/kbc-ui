React = require 'react'
Link = React.createFactory(require('react-router').Link)

module.exports = React.createClass
  displayName: 'ComponentDetailLink'
  propTypes:
    type: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired

  render: ->
    if @props.type == 'extractor'
      routeName = 'extractor-detail'
    else if @props.type == 'writer'
      routeName = 'writer-detail'
    else
      routeName = 'application-detail'

    Link
      to: routeName
      params:
        componentId: @props.componentId
    ,
      @props.children

