React = require 'react'
AuthorizeAccount = require '../../../../google-utils/react/AuthorizeAccount'
AuthorizeAccount = React.createFactory AuthorizeAccount
ActionCreators = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
exGanalStore = require('../../../exGanalStore')
ApplicationStore = require '../../../../../stores/ApplicationStore'

module.exports = React.createClass
  displayName: 'ExGanalAuthorize'
  mixins: [createStoreMixin(exGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configId: configId
    isGeneratingExtLink: exGanalStore.isGeneratingExtLink(configId)
    extLink: exGanalStore.getExtLink(configId)
    isSendingEmail: exGanalStore.isSendingEmail configId
    external: exGanalStore.getConfig(configId)?.get('external')

  render: ->
    AuthorizeAccount
      componentName: 'ex-google-analytics'
      isGeneratingExtLink: @state.isGeneratingExtLink
      extLink: @state.extLink
      refererUrl: @_getReferrer()
      isExtLinkOnly: @_isExtLinkOnly()
      generateExternalLinkFn: =>
        ActionCreators.generateExternalLink(@state.configId)
      sendingLink: exGanalStore.isSendingEmail(@state.configId)
      sendEmailFn: (user, email, message, url) =>
        ActionCreators.sendLinkEmail(
          user: user
          email: email
          message: message
          url: url
        ,
          @state.configId)


  _getReferrer: ->
    origin = window.location.origin
    basepath = ApplicationStore.getProjectPageUrl "extractors/ex-google-analytics"
    referrer = "#{origin}#{basepath}/#{@state.configId}/profiles"
    return referrer

  _isExtLinkOnly: ->
    @state.external and @state.external == '1'
