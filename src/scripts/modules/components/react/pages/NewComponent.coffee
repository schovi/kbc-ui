React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'

ComponentsStore = require '../../stores/ComponentsStore'
NewComponentSelection = require '../components/NewComponentSelection'


{div, table, tbody, tr, td, ul, li, a, span, h2, p} = React.DOM

module.exports = React.createClass
  displayName: 'NewComponent'
  mixins: [createStoreMixin(ComponentsStore)]
  propTypes:
    type: React.PropTypes.string.isRequired

  componentWillReceiveProps: ->
    @setState(@getStateFromStores())

  getStateFromStores: ->
    components: ComponentsStore.getFilteredForType(@props.type).filter (component) ->
      !component.get('flags').includes 'excludeFromNewList'
    filter: ComponentsStore.getFilter(@props.type)

  render: ->
    React.createElement NewComponentSelection,
      className: 'container-fluid kbc-main-content',
      components: @state.components
      filter: @state.filter
      componentType: @props.type