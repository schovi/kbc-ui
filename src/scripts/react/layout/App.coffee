React = require 'react'
RouteHandler = React.createFactory(require('react-router').RouteHandler)
ApplicationStore = require '../../stores/ApplicationStore'

Header = React.createFactory(require '././Header')
Sidebar = React.createFactory(require '././Sidebar')
Notifications = React.createFactory(require './Notifications')
ErrorPage = React.createFactory(require './../pages/ErrorPage')
LoadingPage = React.createFactory(require './../pages/LoadingPage')
ProjectSelect = React.createFactory(require './project-select/ProjectSelect')
PageTitle = React.createFactory(require './PageTitle')

User = React.createFactory(require './User')
UserLinks = React.createFactory(require './UserLinks')

{div} = React.DOM

App = React.createClass
  displayName: 'App'
  propTypes:
    isError: React.PropTypes.bool
    isLoading: React.PropTypes.bool
  getInitialState: ->
    organizations: ApplicationStore.getOrganizations()
    maintainers: ApplicationStore.getMaintainers()
    currentProject: ApplicationStore.getCurrentProject()
    currentAdmin: ApplicationStore.getCurrentAdmin()
    urlTemplates: ApplicationStore.getUrlTemplates()
    xsrf: ApplicationStore.getXsrfToken()
    canCreateProject: ApplicationStore.getCanCreateProject()
    canManageApps: ApplicationStore.getKbcVars().get 'canManageApps'
    homeUrl: ApplicationStore.getUrlTemplates().get 'home'
  render: ->
    div null,
      PageTitle()
      Header
        homeUrl: @state.homeUrl
      div className: 'container-fluid',
        div className: 'row',
          div className: 'col-sm-3 col-md-2 kbc-sidebar',
            ProjectSelect
              organizations: @state.organizations
              currentProject: @state.currentProject
              urlTemplates: @state.urlTemplates
              xsrf: @state.xsrf
              canCreateProject: @state.canCreateProject
            Sidebar()
            div className: 'kbc-sidebar-footer',
              User
                user: @state.currentAdmin
                maintainers: @state.maintainers
                urlTemplates: @state.urlTemplates
                canManageApps: @state.canManageApps
              UserLinks()
          div className: 'col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 kbc-main',
            Notifications()
            if @props.isError
              ErrorPage()
            else if @props.isLoading
              LoadingPage()
            else
              RouteHandler()


module.exports = App
