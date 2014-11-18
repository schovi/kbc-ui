React = require 'react'
Link = React.createFactory(require('react-router').Link)
ActiveState = require('react-router').ActiveState

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
]

Sidebar = React.createClass
  displayName: 'Sidebar'
  mixins: [ ActiveState ]
  renderLinks: ->
    _.map(_pages, (page) ->
      isActive = @isActive(page.id)
      className = if isActive then 'active' else ''
      li className: className, key: page.id,
        Link to: page.id,
          span className: page.icon
          page.title
    , @)
  render: ->
    ul className: 'kbc-nav-sidebar nav nav-sidebar', @renderLinks()

module.exports = Sidebar