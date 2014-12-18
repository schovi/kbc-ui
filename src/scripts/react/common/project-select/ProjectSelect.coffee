React = require 'react'

{div, button, span} = React.DOM

Dropdown = React.createFactory(require './Dropdown.coffee')
DropdownStateMixin = require('react-bootstrap').DropdownStateMixin

module.exports = React.createClass
  displayName: 'ProjectSelect'
  mixins: [DropdownStateMixin]
  propTypes:
    organizations: React.PropTypes.object.isRequired
    currentProjectId: React.PropTypes.number.isRequired

  render: ->
    if @state.open then className = 'open' else ''
    div className: "kbc-project-select dropdown #{className}",
      button onClick: @_handleDropdownClick,
        span null,
          "Project #{@props.currentProjectId}"
          span className: 'kbc-icon-pickerDouble'
      Dropdown
        organizations: @props.organizations
        currentProjectId: @props.currentProjectId

  _handleDropdownClick: (e) ->
    e.preventDefault()
    console.log 'click', @state.open
    @setDropdownState(!@state.open)

