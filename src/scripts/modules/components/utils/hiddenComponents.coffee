ApplicationStore = require '../../../stores/ApplicationStore'

# hardcoded array of hiden components(under construction components)
# possible alternative is hasUI component property
hiddenComponents = []

module.exports =
  isRouteAllowed: (componentId) ->
    isHidden = componentId in hiddenComponents
    adminFeature = "ui-#{componentId}"
    hasAdminFeature = ApplicationStore.hasCurrentAdminFeature(adminFeature)
    #route is not hidden or if it is hidden then it must be explicitely allowed
    # via admin feature
    return (not isHidden) or (isHidden and hasAdminFeature)
