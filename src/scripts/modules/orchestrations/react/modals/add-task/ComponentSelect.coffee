React = require 'react'
ComponentIcon = React.createFactory(require('../../../../../react/common/ComponentIcon').default)

{div, h2, a, table, tbody, tr, td, span} = React.DOM

ComponentSelect = React.createClass
  displayName: 'ComponentSelect'
  propTypes:
    components: React.PropTypes.object.isRequired
    orchestrations: React.PropTypes.object.isRequired
    onComponentSelect: React.PropTypes.func.isRequired

  render: ->
    div null,
      @_renderSection('Extractors', @_getComponentsForType('extractor')),
      @_renderSection('Transformations', @_getComponentsForType('transformation')),
      @_renderSection('Writers', @_getComponentsForType('writer'))
      @_renderSection('Applications', @_getComponentsForType('application'))
      @_renderOrchestratorSection('Orchestrations', @props.components.filter((c) -> c.get('id') == 'orchestrator'))

  _renderSection: (title, components) ->
    if !components || components.size == 0
      return span null
    components = components.map((component) ->
      tr null,
        td null,
          a
            key: component.get('id')
            onClick: @_handleSelect.bind(@, component)
          ,
            ComponentIcon component: component
            ' '
            component.get('name')
            ' '
            span className: 'kbc-icon-arrow-right pull-right'
    , @).toArray()

    div null,
      h2 null, title
      table className: 'table table-striped table-hover kbc-tasks-list',
        tbody null,
          components

  _renderOrchestratorSection: (title, components) ->
    if !components || components.size == 0
      return span null
    components = components.map((component) ->
      tr null,
        td null,
          a
            key: component.get('id')
            onClick: @_handleSelect.bind(@, component)
          ,
            ComponentIcon component: component
            ' '
            component.get('name')
            ' '
            span className: 'kbc-icon-arrow-right pull-right'
    , @).toArray()

    div null,
      h2 null, title
      table className: 'table table-striped table-hover kbc-tasks-list',
        tbody null,
          components if @props.orchestrations.count()

  _handleSelect: (component) ->
    @props.onComponentSelect(component)

  _getComponentsForType: (type, filter) ->
    @props.components.filter((component) ->
      component.get('type') == type
    )


module.exports = ComponentSelect
