_ = require 'underscore'
ApplicationStore = require '../../../stores/ApplicationStore'

# hardcoded array of hiden components(under construction components)
# possible alternative is hasUI component property
hiddenComponents = ['wr-dropbox']

module.exports =
  isRouteAllowed: (componentId) ->
    isHidden = componentId in hiddenComponents
    adminFeature = "ui-devel-preview"
    hasAdminFeature = ApplicationStore.hasCurrentAdminFeature(adminFeature)
    #route is not hidden or if it is hidden then it must be explicitely allowed
    # via admin feature
    return  (not isHidden) or (isHidden and hasAdminFeature)

  filterHiddenRoutes: (routes) ->
    stack = [routes]
    while not _.isEmpty(stack)
      tmpRoutes = stack.pop()
      result = []
      if not tmpRoutes.childRoutes
        continue
      for r in tmpRoutes.childRoutes
        if @isRouteAllowed(r.name)
          stack.push(r)
          result.push(r)
      tmpRoutes.childRoutes = result
    return routes
