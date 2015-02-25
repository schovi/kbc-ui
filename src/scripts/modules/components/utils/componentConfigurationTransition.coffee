RoutesStore = require '../../../stores/RoutesStore'
ComponentsStore = require '../stores/ComponentsStore'

module.exports = (componentId, configurationId) ->
  if RoutesStore.hasRoute(componentId)
    RoutesStore.getRouter().transitionTo componentId,
      config: configurationId
  else if ComponentsStore.hasComponentLegacyUI(componentId)
    window.location = ComponentsStore.getComponentDetailLegacyUrl(componentId, configurationId)
  else
    throw new Error("Component #{componentId} has no UI to link to")