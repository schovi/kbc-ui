React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
immutableMixin = require '../../../../react/mixins/ImmutableRendererMixin'
storeProvisioning = require '../../storeProvisioning'

componentId = 'keboola.ex-db-pgsql'
module.exports = React.createClass
  displayName: "ExDbQuerNameEdit"
  mixins: [createStoreMixin(storeProvisioning.componentsStore), immutableMixin]
  propTypes:
    configId: React.PropTypes.string.isRequired
    queryId: React.PropTypes.number.isRequired

  getStateFromStores: ->
    ExDbStore = storeProvisioning.createStore(componentId, @props.configId)
    name: ExDbStore.getConfigQuery(@props.queryId)?.get 'name'

  render: ->
    if @state.name
      React.DOM.span null,
        @state.name
    else
      React.DOM.span className: 'text-muted',
        'Untitled Query'
