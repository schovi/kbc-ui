React = require 'react'
{span, div, a, p, h2} = React.DOM

createStoreMixin = require '../../../../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../../../../../components/stores/InstalledComponentsStore'
RoutesStore = require '../../../../../../../stores/RoutesStore'

module.exports = React.createClass

  displayName: 'GeneeaAppDetail'

  mixins: [createStoreMixin(InstalledComponentsStore)]
  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    config = InstalledComponentsStore.getConfigData("geneea-topic-detection", configId)
    config: config


  render: ->
    console.log "rendering geneea detail", @state.config.toJS()
    div null, "detail"
