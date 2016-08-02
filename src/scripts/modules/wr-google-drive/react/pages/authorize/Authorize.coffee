React = require('react')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
WrGdriveStore = require '../../../wrGdriveStore'
ComponentsStore = require '../../../../components/stores/ComponentsStore'
RoutesStore = require '../../../../../stores/RoutesStore'
ApplicationStore = require '../../../../../stores/ApplicationStore'

ActionCreators = require '../../../wrGdriveActionCreators'

AuthorizeAccount = require '../../../../google-utils/react/AuthorizeAccount'
AuthorizeAccount = React.createFactory AuthorizeAccount

{div, span, form } = React.DOM

module.exports = React.createClass
  displayName: 'authorize'
  mixins: [createStoreMixin(WrGdriveStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    token = ApplicationStore.getSapiTokenString()

    gdriveComponent: ComponentsStore.getComponent('wr-google-drive')
    configId: configId
    token: token


  render: ->
    AuthorizeAccount
      componentName: 'wr-google-drive'
      refererUrl: @_getReferrer()
      isInstantOnly: true


  _renderExtLink: ->
    div className: 'pre', @state.extLink.get('link')
  _generateExternalLink: ->
    ActionCreators.generateExternalLink(@state.configId)

  _getReferrer: ->
    origin = window.location.origin
    basepath = ApplicationStore.getProjectPageUrl "writers/wr-google-drive"
    referrer = "#{origin}#{basepath}/#{@state.configId}"
    return referrer #encodeURIComponent(referrer)
