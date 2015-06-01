RoutesStore = require '../../../stores/RoutesStore'
ComponentsStore = require '../stores/ComponentsStore'

module.exports = (componentId) ->
  return true if RoutesStore.hasRoute(componentId)
  return true if ComponentsStore.hasComponentLegacyUI(componentId)
  return false
