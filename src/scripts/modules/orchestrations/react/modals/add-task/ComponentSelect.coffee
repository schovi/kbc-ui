React = require 'react'
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon.coffee'))

{div, h2, a} = React.DOM

ComponentSelect = React.createClass
  displayName: 'ComponentSelect'
  propTypes:
    components: React.PropTypes.object.isRequired
    onComponentSelect: React.PropTypes.func.isRequired

  render: ->
    extractors = @props.components.filter((component) -> component.get('type') == 'extractor')
    writers = @props.components.filter((component) -> component.get('type') == 'writer')
    transformations = @props.components.filter((component) -> component.get('type') == 'transformation')

    div null,
      @_renderSection('Extractors', extractors),
      @_renderSection('Transformations', transformations),
      @_renderSection('Writers', writers)

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


module.exports = ComponentSelect