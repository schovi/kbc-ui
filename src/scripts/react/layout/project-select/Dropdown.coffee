React = require 'react'
fuzzy = require 'fuzzy'
{List, Map} = require 'immutable'
_ = require 'underscore'
ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
NewProjectModal = React.createFactory(require '../NewProjectModal')

{div, ul, li, a, span, input} = React.DOM

module.exports = React.createClass
  displayName: 'ProjectSelectDropdown'
  propTypes:
    organizations: React.PropTypes.object.isRequired
    currentProjectId: React.PropTypes.number.isRequired
    urlTemplates: React.PropTypes.object.isRequired
    xsrf: React.PropTypes.string.isRequired
    open: React.PropTypes.bool.isRequired
    canCreateProject: React.PropTypes.bool.isRequired

  getInitialState: ->
    query: ''
    selectedProjectId: null
    selectedOrganizationId: null

  componentDidUpdate: (prevProps) ->
    # focus search on dropdown open
    if @props.open && @props.open != prevProps.open
      @refs.searchInput.getDOMNode().focus()

  render: ->
    div className: 'dropdown-menu',
      ul className: 'list-unstyled',
        li className: 'dropdown-header kb-nav-search kbc-search',
          span className: 'kbc-icon-search'
          input
            style:
              color: '#fff'
            className: 'form-control'
            placeholder: 'Search your projects'
            value: @state.query
            ref: 'searchInput'
            onChange: @_handleQueryChange
            onKeyDown: @_handleKeyDown

      @_projectsList()
      @_newProject() if @props.canCreateProject


  _projectsList: ->
    organizations = @_organizationsFiltered()
    if organizations.size
      elements = organizations.map((organization) ->

        organizationElement = li className: 'dropdown-header', key: "org-#{organization.get('id')}",
          a
            href: @_organizationUrl(organization.get 'id')
            className: if @state.selectedOrganizationId == organization.get('id') then 'active' else ''
          ,
            organization.get('name')

        projectElements = organization.get('projects').map((project) ->
          li key: "proj-#{project.get('id')}",
            a
              href: @_projectUrl(project.get 'id')
              className: if @state.selectedProjectId == project.get('id') then 'active' else ''
            ,
              project.get('name')
        , @).toArray()

        [[organizationElement], projectElements]
      , @).flatten().toArray()
    else
      elements = li className: 'dropdown-header', 'No projects found'

    ul className: 'list-unstyled kbc-project-select-results', elements

  _newProject: ->
    ul className: 'list-unstyled kbc-project-select-new',
      li null,
        ModalTrigger modal: NewProjectModal(
          urlTemplates: @props.urlTemplates
          xsrf: @props.xsrf
          organizations: @props.organizations
        ),
          span null,
            span className: 'fa fa-plus-circle'
            ' New Project'

  _organizationsFiltered: ->
    filter = @state.query
    @props.organizations
    .map (organization) ->
      organization.set 'projects', organization.get('projects').filter((project) ->
        fuzzy.match(filter, project.get('name'))
      )
    .filter (organization) ->
      organization.get('projects').size > 0

  _projectUrl: (id) ->
    _.template(@props.urlTemplates.get('project'))(projectId: id)

  _organizationUrl: (id) ->
    _.template(@props.urlTemplates.get('organization'))(organizationId: id)

  _handleQueryChange: (event) ->
    @setState
      query: event.target.value

  _handleKeyDown: (event) ->
    console.log 'key down', event.key, event.keyCode
    switch event.key
      when 'ArrowDown' then @_selectNextProjectOrOrganization()
      when 'ArrowUp' then @_selectPreviousProjectOrOrganization()
      when 'Enter' then @_goToSelectedProjectOrOrganization()


  _selectNextProjectOrOrganization: ->
    @_moveSelectedProjecteOrOrganization false

  _selectPreviousProjectOrOrganization: ->
    @_moveSelectedProjecteOrOrganization true

  _moveSelectedProjecteOrOrganization: (previous = false) ->
    organizations = @_organizationsFiltered()
    return if !organizations.count()

    # flat map of organizations and projects
    organizationsAndProjects = organizations
    .map (organization) ->
      org = Map
        type: 'organization'
        id: organization.get 'id'

      projects = organization.get 'projects'
      .map (project) ->
        Map
          type: 'project'
          id: project.get 'id'

      List [List([org]), projects]
    .flatten(2)


    if !@state.selectedProjectId && !@state.selectedOrganizationId
      if previous
        item = organizationsAndProjects.last()
      else
        item = organizationsAndProjects.first()

      return @_setSelectedItem item

    selectedIndex = organizationsAndProjects.findIndex (item) ->
      if @state.selectedProjectId
        id = @state.selectedProjectId
        type = 'project'
      else
        id = @state.selectedOrganizationId
        type = 'organization'
      item.get('id') == id && item.get('type') == type
    , @


    newIndex = if previous then selectedIndex - 1 else selectedIndex + 1
    newSelected = organizationsAndProjects.get(newIndex)
    if !newSelected
      # go back to first which is always organization
      return @setState
        selectedProjectId: null
        selectedOrganizationId: organizationsAndProjects.first().get 'id'
    else
      return @_setSelectedItem newSelected

  _goToSelectedProjectOrOrganization: ->
    if @state.selectedProjectId
      window.location.href = @_projectUrl @state.selectedProjectId
    else if @state.selectedOrganizationId
      window.location.href = @_organizationUrl @state.selectedOrganizationId

  _setSelectedItem: (item) ->
    if item.get('type') == 'organization'
      @setState
        selectedProjectId: null
        selectedOrganizationId: item.get 'id'
    else
      @setState
        selectedProjectId: item.get 'id'
        selectedOrganizationId: null
