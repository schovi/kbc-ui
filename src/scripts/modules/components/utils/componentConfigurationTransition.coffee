RoutesStore = require '../../../stores/RoutesStore'
ComponentsStore = require '../stores/ComponentsStore'

module.exports = (componentId, configurationId) ->
  components = ComponentsStore.getAll()

  if RoutesStore.hasRoute(componentId)
    RoutesStore.getRouter().transitionTo componentId,
      config: configurationId
  else if ComponentsStore.hasComponentLegacyUI(componentId)
    window.location = ComponentsStore.getComponentDetailLegacyUrl(componentId, configurationId)
  else if components.getIn([componentId, 'flags']).includes 'genericUI'
    RoutesStore.getRouter().transitionTo "generic-detail-" + components.getIn([componentId, 'type']),
      component: componentId
      config: configurationId
  else
    throw new Error("Component #{componentId} has no UI to link to")


