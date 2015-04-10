React = require 'react'
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon'))

{div, h2, a} = React.DOM

ComponentSelect = React.createClass
  displayName: 'ComponentSelect'
  propTypes:
    components: React.PropTypes.object.isRequired
    onComponentSelect: React.PropTypes.func.isRequired

  render: ->
    div null,
      @_renderSection('Extractors', @_getComponentsForType('extractor')),
      @_renderSection('Transformations', @_getComponentsForType('transformation')),
      @_renderSection('Recipes', @_getComponentsForType('recipe'))
      @_renderSection('Writers', @_getComponentsForType('writer'))

  _renderSection: (title, components) ->
    components = components.map((component) ->
      a
        className: 'list-group-item'
        key: component.get('id')
        onClick: @_handleSelect.bind(@, component)
      ,
        ComponentIcon component: component
        ' '
        component.get('name')
    , @).toArray()

    div null,
      h2 null, title,
      div className: 'list-group',
        components

  _handleSelect: (component) ->
    @props.onComponentSelect(component)

  _getComponentsForType: (type) ->
    @props.components.filter((component) -> component.get('type') == type)


module.exports = ComponentSelect
