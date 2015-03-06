React = require 'react'
AuthorizeAccount = require '../../../../google-utils/react/AuthorizeAccount'
AuthorizeAccount = React.createFactory AuthorizeAccount
ActionCreators = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
exGanalStore = require('../../../exGanalStore')

module.exports = React.createClass
  displayName: 'ExGanalAuthorize'
  mixins: [createStoreMixin(exGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configId: configId
    isGeneratingExtLink: exGanalStore.isGeneratingExtLink(configId)
    extLink: exGanalStore.getExtLink(configId)

  render: ->
    AuthorizeAccount
      componentName: 'ex-google-analytics'
      isGeneratingExtLink: @state.isGeneratingExtLink
      extLink: @state.extLink
      refererUrl: @_getReferrer()
      generateExternalLinkFn: =>
        ActionCreators.generateExternalLink(@state.configId)


  _getReferrer: ->
    {origin, pathname, search} = window.location
    basepath = "#{origin}#{pathname}#{search}#/extractors/ex-google-analytics"
    referrer = "#{basepath}/#{@state.configId}/profiles"
    return referrer
