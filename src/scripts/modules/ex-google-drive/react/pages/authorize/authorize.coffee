React = require('react')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGdriveStore = require '../../../exGdriveStore'
ComponentsStore = require '../../../../components/stores/ComponentsStore'
RoutesStore = require '../../../../../stores/RoutesStore'
ApplicationStore = require '../../../../../stores/ApplicationStore'

ActionCreators = require '../../../exGdriveActionCreators'

AuthorizeAccount = require '../../../../google-utils/react/AuthorizeAccount'
AuthorizeAccount = React.createFactory AuthorizeAccount

{div, span, form } = React.DOM

module.exports = React.createClass
  displayName: 'authorize'
  mixins: [createStoreMixin(ExGdriveStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    config = ExGdriveStore.getConfig configId
    token = ApplicationStore.getSapiTokenString()
    external: config.get 'external'
    gdriveComponent: ComponentsStore.getComponent('ex-google-drive')
    configId: configId
    token: token
    isGeneratingExtLink: ExGdriveStore.isGeneratingExtLink(configId)
    extLink: ExGdriveStore.getExtLink(configId)

  render: ->
    AuthorizeAccount
      componentName: 'ex-google-drive'
      isGeneratingExtLink: @state.isGeneratingExtLink
      extLink: @state.extLink
      isExtLinkOnly: @_isExtLinkOnly()
      refererUrl: @_getReferrer()
      generateExternalLinkFn: =>
        ActionCreators.generateExternalLink(@state.configId)

  _renderExtLink: ->
    div className: 'pre', @state.extLink.get('link')
  _generateExternalLink: ->
    ActionCreators.generateExternalLink(@state.configId)

  _getReferrer: ->
    {origin, pathname, search} = window.location
    basepath = "#{origin}#{pathname}#{search}#/extractors/ex-google-drive"
    referrer = "#{basepath}/#{@state.configId}/sheets"
    return referrer #encodeURIComponent(referrer)

  _isExtLinkOnly: ->
    @state.external and @state.external == '1'
