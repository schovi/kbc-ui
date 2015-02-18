React = require 'react'
RoutesStore = require '../../../../stores/RoutesStore'
ComponentsStore = require '../../stores/ComponentsStore'

Link = React.createFactory require('react-router').Link
{a, span} = React.DOM

###
  Creates link depending on component type
  - Link to current SPA page if UI is present
  - Link to legacy UI page
  - Disabled link if UI is not prepared at all

###
module.exports = React.createClass
  displayName: 'ComponentConfigurationLink'
  propTypes:
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    if RoutesStore.hasRoute(@props.componentId)
      Link
        to: @props.componentId
        params:
          config: @props.configId
      ,
        @props.children
    else if ComponentsStore.hasComponentLegacyUI(@props.componentId)
      a href: ComponentsStore.getComponentDetailLegacyUrl(@props.componentId, @props.configId),
        @props.children
    else
      span className: 'text-muted',
        @props.children

