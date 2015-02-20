React = require 'react'

{div, button, span} = React.DOM


Dropdown = React.createFactory(require './Dropdown')
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
    if @state.open then className = 'open' else ''
    div className: "kbc-project-select dropdown #{className}",
      button onClick: @_handleDropdownClick, title: @props.currentProject.get('name'),
        span null,
          span className: 'kbc-icon-pickerDouble'
          span className: 'kbc-project-name',
            @props.currentProject.get('name')
      Dropdown
        organizations: @props.organizations
        currentProjectId: @props.currentProject.get('id')
        urlTemplates: @props.urlTemplates
        xsrf: @props.xsrf
        canCreateProject: @props.canCreateProject
        open: @state.open

  _handleDropdownClick: (e) ->
    e.preventDefault()
    @setDropdownState(!@state.open)
