React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'

ComponentIcon = React.createFactory(require '../../../../react/common/ComponentIcon')
SearchRow = React.createFactory(require '../../../../react/common/SearchRow')
Link = React.createFactory(require('react-router').Link)

ComponentsStore = require '../../stores/ComponentsStore'
ComponentsActionCreators = require '../../ComponentsActionCreators'


{div, table, tbody, tr, td, ul, li, a, span, h2, p} = React.DOM

ComponentBox = React.createClass
  displayName: 'ComponentBox'
  propTypes:
    component: React.PropTypes.object.isRequired

  shouldComponentUpdate: (nextProps) ->
    @props.component == nextProps.component

  render: ->
    component = @props.component
    div className: 'col-sm-4',
      div className: 'panel',
        div className: 'panel-body text-center',
          ComponentIcon
            component: component
            size: '64'
          h2 null, component.get('name')
          p null, component.get('description')
          Link
            className: 'btn btn-success btn-lg'
            to: 'new-extractor-form'
            params:
              componentId: component.get 'id'
          ,
            span className: 'kbc-icon-plus', 'Add'

createNewComponentPage = (type) ->

  NewComponent = React.createClass
    displayName: 'NewComponent'
    mixins: [createStoreMixin(ComponentsStore)]

    componentWillReceiveProps: ->
      @setState(@getStateFromStores())

    getStateFromStores: ->
      components: ComponentsStore.getFilteredForType(type)
      filter: ComponentsStore.getFilter(type)

    render: ->
      div className: 'container-fluid kbc-main-content',
        SearchRow(className: 'row kbc-search-row', onChange: @_handleFilterChange, query: @state.filter)
        @renderComponents()

    _handleFilterChange: (query) ->
      ComponentsActionCreators.setComponentsFilter(query, type)

    renderComponents: ->
      @state.components
      .toIndexedSeq()
      .sortBy((component) -> component.get('name'))
      .groupBy((component, i) -> Math.floor(i / 3))
      .map(@renderComponentsRow, @)
      .toArray()

    renderComponentsRow: (components) ->
      div className: 'row kbc-extractors-select', components.map((component) ->
        React.createElement ComponentBox, component: component, key: component.get('id')
      ).toArray()

module.exports = createNewComponentPage