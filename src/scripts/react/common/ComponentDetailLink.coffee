React = require 'react'
Link = React.createFactory(require('react-router').Link)

module.exports = React.createClass
  displayName: 'ComponentDetailLink'
  propTypes:
    type: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired

  render: ->
    if @props.type == 'extractor'
      routeName = 'generic-detail-extractor'
    else if @props.type == 'writer'
      routeName = 'generic-detail-writer'
    else
      routeName = 'generic-detail-application'

    Link
      to: routeName
      params:
        component: @props.componentId
    ,
      @props.children

