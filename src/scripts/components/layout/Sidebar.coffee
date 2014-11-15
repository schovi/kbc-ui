React = require 'react'
Link = React.createFactory(require('react-router').Link)
ActiveState = require('react-router').ActiveState

_ = require 'underscore'

{ul, li, a} = React.DOM

_pages = [
    id: 'home'
    title: 'Overview'
  ,
    id: 'extractors'
    title: 'Extractors'
  ,
    id: 'transformations'
    title: 'Transformations'
  ,
    id: 'writers'
    title: 'Writers'
  ,
    id: 'orchestrations'
    title: 'Orchestrations'
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
          page.title
    , @)
  render: ->
    ul className: 'kbc-nav-sidebar nav nav-sidebar', @renderLinks()

module.exports = Sidebar