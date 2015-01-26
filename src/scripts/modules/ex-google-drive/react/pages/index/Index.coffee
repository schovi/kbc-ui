React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'

getStateFromStores: ->
  config = RoutesStore.getRouterState().getIn ['params', 'config']
  configuration: ExDbStore.getConfig config
  deletingQueries: ExDbStore.getDeletingQueries config
