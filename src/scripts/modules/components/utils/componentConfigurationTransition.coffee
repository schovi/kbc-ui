Immutable = require 'immutable'
RoutesStore = require '../../../stores/RoutesStore'
ComponentsStore = require '../stores/ComponentsStore'
{GENERIC_DETAIL_PREFIX} = require('../Constants').Routes

module.exports = (componentId, configurationId) ->
  components = ComponentsStore.getAll()

  if RoutesStore.hasRoute(componentId)
    RoutesStore.getRouter().transitionTo componentId,
      config: configurationId
  else if ComponentsStore.hasComponentLegacyUI(componentId)
    window.location = ComponentsStore.getComponentDetailLegacyUrl(componentId, configurationId)
  else if components.getIn([componentId, 'flags'], Immutable.List()).includes('genericUI') or
      components.getIn([componentId, 'flags'], Immutable.List()).includes('genericDockerUI')
    RoutesStore.getRouter().transitionTo GENERIC_DETAIL_PREFIX + components.getIn([componentId, 'type']) + '-config',
      component: componentId
      config: configurationId
  else
    throw new Error("Component #{componentId} has no UI to link to")


