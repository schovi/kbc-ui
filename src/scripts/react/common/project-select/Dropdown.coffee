React = require 'react'
fuzzy = require 'fuzzy'

{div, ul, li, a, span, input} = React.DOM

module.exports = React.createClass
  displayName: 'ProjectSelectDropdown'
  propTypes:
    organizations: React.PropTypes.object.isRequired
    currentProjectId: React.PropTypes.number.isRequired

  getInitialState: ->
    query: ''

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
            onChange: @_handleQueryChange

      @_projectsList()
      ul className: 'list-unstyled kbc-project-select-new',
        li null,
          a null,
            span className: 'fa fa-plus-circle'
            ' New Project'

  _projectsList: ->
    organizations = @_organizationsFiltered()
    if organizations.size
      elements = organizations.map((organization) ->

        organizationElement = li className: 'dropdown-header', key: "org-#{organization.get('id')}",
          a null, organization.get('name')

        projectElements = organization.get('projects').map((project) ->
          li key: "proj-#{project.get('id')}",
            a null, project.get('name')
        ).toArray()

        [[organizationElement], projectElements]
      ).flatten().toArray()
    else
      elements = li className: 'dropdown-header', 'No projects found'

    ul className: 'list-unstyled kbc-project-select-results', elements

  _organizationsFiltered: ->
    filter = @state.query
    @props.organizations.map((organization) ->
      organization.set 'projects', organization.get('projects').filter((project) ->
        fuzzy.match(filter, project.get('name'))
      )
    ).filter((organization) ->
      organization.get('projects').size > 0
    )

  _handleQueryChange: (event) ->
    @setState
      query: event.target.value