_ = require 'underscore'
ApplicationStore = require '../../../stores/ApplicationStore'

# hardcoded array of hiden components(under construction components)
# possible alternative is hasUI component property
hiddenComponents = ['wr-dropbox', 'wr-google-drive']

module.exports =
  isComponentAllowed: (componentId) ->
    isHidden = componentId in hiddenComponents
    #route is not hidden or if it is hidden then it must be explicitely allowed
    # via admin feature
    return  (not isHidden) || @hasDevelPreview(componentId)

  hasDevelPreview: (componentId) ->
    isHidden = componentId in hiddenComponents
    hasAdminFeature = @hasCurrentUserDevelPreview()
    isHidden && hasAdminFeature

  hasCurrentUserDevelPreview: ->
    adminFeature = "ui-devel-preview"
    return ApplicationStore.hasCurrentAdminFeature(adminFeature)

  filterHiddenRoutes: (routes) ->
    stack = [routes]
    while not _.isEmpty(stack)
      tmpRoutes = stack.pop()
      result = []
      if not tmpRoutes.childRoutes
        continue
      for r in tmpRoutes.childRoutes
        if @isComponentAllowed(r.name)
          stack.push(r)
          result.push(r)
      tmpRoutes.childRoutes = result
    return routes
