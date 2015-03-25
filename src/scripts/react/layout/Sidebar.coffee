React = require 'react'
Link = React.createFactory(require('react-router').Link)
State = require('react-router').State
RoutesStore = require '../../stores/RoutesStore'
ApplicationStore = require '../../stores/ApplicationStore'

_ = require 'underscore'

{ul, li, a, span} = React.DOM

_pages = [
    id: 'home'
    title: 'Overview'
    icon: 'kbc-icon-overview'
  ,
    id: 'extractors'
    title: 'Extractors'
    icon: 'kbc-icon-extractors'
  ,
    id: 'transformations'
    title: 'Transformations'
    icon: 'kbc-icon-transformations'
  ,
    id: 'writers'
    title: 'Writers'
    icon: 'kbc-icon-writers'
  ,
    id: 'orchestrations'
    title: 'Orchestrations'
    icon: 'kbc-icon-orchestration'
  ,
    id: 'storage'
    title: 'Storage'
    icon: 'kbc-icon-storage'
  ,
    id: 'jobs'
    title: 'Jobs'
    icon: 'kbc-icon-storage'
  ,
    id: 'applications'
    title: 'Applications'
    icon: 'kbc-icon-storage'

]

Sidebar = React.createClass
  displayName: 'Sidebar'
  mixins: [ State ]
  renderLinks: ->
    _.map(_pages, (page) ->
      isActive = @isActive(page.id)
      className = if isActive then 'active' else ''
      li className: className, key: page.id,
        if RoutesStore.hasRoute(page.id)
          Link to: page.id,
            span className: page.icon
            span null, page.title
        else
          a href: ApplicationStore.getProjectPageUrl(page.id),
            span className: page.icon
            span null, page.title

    , @)
  render: ->
    ul className: 'kbc-nav-sidebar nav nav-sidebar', @renderLinks()

module.exports = Sidebar
