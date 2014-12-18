React = require 'react'
RouteHandler = React.createFactory(require('react-router').RouteHandler)
ApplicationStore = require '../../stores/ApplicationStore.coffee'

Header = React.createFactory(require '././Header.coffee')
Sidebar = React.createFactory(require '././Sidebar.coffee')
ErrorPage = React.createFactory(require './../pages/ErrorPage.coffee')
LoadingPage = React.createFactory(require './../pages/LoadingPage.coffee')
ProjectSelect = React.createFactory(require '../common/project-select/ProjectSelect.coffee')

{div} = React.DOM

App = React.createClass
  displayName: 'App'
  propTypes:
    isError: React.PropTypes.bool
    isLoading: React.PropTypes.bool
  getInitialState: ->
    organizations: ApplicationStore.getOrganizations()
    currentProjectId: ApplicationStore.getCurrentProjectId()
  render: ->
    div null,
      Header(),
      div className: 'container-fluid',
        div className: 'row',
          div className: 'col-sm-3 col-md-2 kbc-sidebar',
            ProjectSelect
              organizations: @state.organizations
              currentProjecTId: @state.currentProjectId
            Sidebar()
          div className: 'col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 kbc-main',
            if @props.isError
              ErrorPage()
            else if @props.isLoading
              LoadingPage()
            else
              RouteHandler()


module.exports = App