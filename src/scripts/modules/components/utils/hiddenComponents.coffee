_ = require 'underscore'
ApplicationStore = require '../../../stores/ApplicationStore'

# hardcoded array of hiden components(under construction components)
# possible alternative is hasUI component property
hiddenComponents = ['wr-dropbox']

module.exports =
  isRouteAllowed: (componentId) ->
    isHidden = componentId in hiddenComponents
    adminFeature = "ui-#{componentId}"
    hasAdminFeature = ApplicationStore.hasCurrentAdminFeature(adminFeature)
    #route is not hidden or if it is hidden then it must be explicitely allowed
    # via admin feature
    return  (not isHidden) or (isHidden and hasAdminFeature)



  filterHiddenRoutes: (routes) ->
    filterChildRoutes = (childRoutes) =>
      if not childRoutes
        return []
      result = []
      for r in childRoutes
        if @isRouteAllowed(r.name)
          result.push @filterHiddenRoutes(r)
      return result
    routes.childRoutes = filterChildRoutes(routes.childRoutes)
    return routes
