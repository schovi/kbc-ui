React = require('react')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
ExGdriveStore = require '../../../exGdriveStore.coffee'
ComponentsStore = require '../../../../components/stores/ComponentsStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'
ApplicationStore = require '../../../../../stores/ApplicationStore.coffee'

ActionCreators = require '../../../exGdriveActionCreators.coffee'

TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)
Button = React.createFactory(require('react-bootstrap').Button)
Input = React.createFactory(require('react-bootstrap').Input)
Loader = React.createFactory(require '../../../../../react/common/Loader.coffee')
{div, span, form } = React.DOM

module.exports = React.createClass
  displayName: 'authorize'
  mixins: [createStoreMixin(ExGdriveStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    token = ApplicationStore.getSapiTokenString()
    gdriveComponent: ComponentsStore.getComponent('ex-google-drive')
    configId: configId
    token: token
    isGeneratingExtLink: ExGdriveStore.isGeneratingExtLink(configId)
    extLink: ExGdriveStore.getExtLink(configId)

  render: ->
    @_getReferrer()
    div {className: 'container-fluid kbc-main-content'},
      TabbedArea defaultActiveKey: 'instant', animation: false,
        TabPane eventKey: 'instant', tab: 'Instant Authorization',
          form {className: 'form-horizontal', action: @_getOAuthUrl(), method: 'POST'},
            div  className: 'row',
              div className: 'well',
                'Authorize google drive account now.',
              @_createHiddenInput('token', @state.token)
              @_createHiddenInput('account', @state.configId)
              @_createHiddenInput('referrer', @_getReferrer())
              Button
                className: 'btn btn-primary'
                type: 'submit',
                  'Authorize Google Drive account now'
                #onClick: @_handleCancel

        TabPane eventKey: 'external', tab: 'External Authorization',
          form {className: 'form-horizontal'},
            div className: 'row',
              div className: 'well',
                'Generated external link allows to authorize the google drive account\
                 without having an access to the KBC. The link is temporary valid and \
                 expires 48 hours after the generation.'
              @_renderExtLink() if @state.extLink
              Button
                className: 'btn btn-primary'
                onClick: @_generateExternalLink
                disabled: @state.isGeneratingExtLink
                type: 'button',
                  if @state.extLink
                    'Regenerate External Link'
                  else
                    'Generate External Link'
              Loader() if @state.isGeneratingExtLink
  _renderExtLink: ->
    div className: 'pre', @state.extLink.get('link')
  _generateExternalLink: ->
    ActionCreators.generateExternalLink(@state.configId)


  _getOAuthUrl: ->
    endpoint = @state.gdriveComponent.get('uri')
    oauthUrl = "#{endpoint}/oauth"
    return oauthUrl

  _getReferrer: ->
    {origin, pathname, search} = window.location
    basepath = "#{origin}#{pathname}#{search}#/extractors/ex-google-drive"
    referrer = "#{basepath}/#{@state.configId}/sheets"
    return referrer #encodeURIComponent(referrer)

  _createHiddenInput: (name, value) ->
    Input
      name: name
      type: 'hidden'
      value: value
