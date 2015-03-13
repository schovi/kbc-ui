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
    isSendingEmail: exGanalStore.isSendingEmail configId

  render: ->
    AuthorizeAccount
      componentName: 'ex-google-analytics'
      isGeneratingExtLink: @state.isGeneratingExtLink
      extLink: @state.extLink
      refererUrl: @_getReferrer()
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
    {origin, pathname, search} = window.location
    basepath = "#{origin}#{pathname}#{search}#/extractors/ex-google-analytics"
    referrer = "#{basepath}/#{@state.configId}/profiles"
    return referrer
