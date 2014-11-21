React = require 'react'

ComponentIcon = React.createFactory(require '../common/ComponentIcon.coffee')
SearchRow = React.createFactory(require '../common/SearchRow.coffee')
ComponentsStore = require '../../stores/ComponentsStore.coffee'
ComponentsActionCreators = require '../../actions/ComponentsActionCreators.coffee'

{div, table, tbody, tr, td, ul, li, a, span, h2, p} = React.DOM

getStateFromStores = (type) ->
  components: ComponentsStore.getFilteredForType(type)
  filter: ComponentsStore.getFilter(type)

NewComponent = React.createClass
  displayName: 'NewComponent'

  getInitialState: ->
    getStateFromStores(@props.mode)

  componentWillReceiveProps: (nextProps) ->
    @setState(getStateFromStores(nextProps.mode))

  componentDidMount: ->
    ComponentsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    ComponentsStore.removeChangeListener(@_onChange)

  render: ->
    div className: 'container-fluid',
      SearchRow(onChange: @_handleFilterChange, query: @state.filter)
      @renderComponents()

  _handleFilterChange: (query) ->
    ComponentsActionCreators.setComponentsFilter(query, @props.mode)

  renderComponents: ->
    @state.components
    .toIndexedSeq()
    .sortBy((component) -> component.get('name'))
    .groupBy((component, i) -> Math.floor(i / 3))
    .map(@renderComponentsRow, @)
    .toArray()

  renderComponentsRow: (components) ->
    div className: 'row kbc-extractors-select', components.map(@renderComponent, @).toArray()

  renderComponent: (component) ->
    div className: 'col-sm-4',
      div className: 'panel',
        div className: 'panel-body text-center',
          ComponentIcon component: component, size: '32'
          h2 null, component.get('name')
          p null, component.get('description')
          a className: 'btn btn-success btn-lg',
            span className: 'kbc-icon-plus', 'Add'

  _onChange: ->
    @setState(getStateFromStores(@props.mode))

module.exports = NewComponent