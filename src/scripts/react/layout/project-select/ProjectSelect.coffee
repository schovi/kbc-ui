React = require 'react'

{div, button, span} = React.DOM


ProjectsList = require './List'
DropdownStateMixin = require('react-bootstrap').DropdownStateMixin

module.exports = React.createClass
  displayName: 'ProjectSelect'
  mixins: [DropdownStateMixin]
  propTypes:
    organizations: React.PropTypes.object.isRequired
    currentProject: React.PropTypes.object.isRequired
    urlTemplates: React.PropTypes.object.isRequired
    xsrf: React.PropTypes.string.isRequired
    canCreateProject: React.PropTypes.bool.isRequired

  render: ->
    if @state?.open then className = 'open' else ''
    div className: "kbc-project-select dropdown #{className}",
      button onClick: @_handleDropdownClick, title: @props.currentProject.get('name'),
        span null,
          span className: 'kbc-icon-picker-double'
          span className: 'kbc-project-name',
            @props.currentProject.get('name')
      div className: 'dropdown-menu',
      React.createElement ProjectsList,
        organizations: @props.organizations
        currentProjectId: @props.currentProject.get('id')
        urlTemplates: @props.urlTemplates
        xsrf: @props.xsrf
        canCreateProject: @props.canCreateProject
        focus: @state?.open or false

  _handleDropdownClick: (e) ->
    e.preventDefault()
    @setDropdownState(!@state?.open)
