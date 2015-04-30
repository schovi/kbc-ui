
React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
immutableMixin = require '../../../../react/mixins/ImmutableRendererMixin'
ExDbStore = require '../../exDbStore'

module.exports = React.createClass
  displayName: "ExDbQuerNameEdit"
  mixins: [createStoreMixin(ExDbStore), immutableMixin]
  propTypes:
    configId: React.PropTypes.string.isRequired
    queryId: React.PropTypes.number.isRequired

  getStateFromStores: ->
    name: ExDbStore.getConfigQuery(@props.configId, @props.queryId)?.get 'name'

  render: ->
    if @state.name
      React.DOM.span null,
        @state.name
    else
      React.DOM.span className: 'text-muted',
        'Untitled Query'
