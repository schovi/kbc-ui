React = require('react')
ComponentsStore = require '../../components/stores/ComponentsStore'
RoutesStore = require '../../../stores/RoutesStore'
ApplicationStore = require '../../../stores/ApplicationStore'
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)
Button = React.createFactory(require('react-bootstrap').Button)
Input = React.createFactory(require('react-bootstrap').Input)
Loader = React.createFactory(require('kbc-react-components').Loader)
{button, input, textarea, label, div, span, form, pre } = React.DOM

module.exports = React.createClass
  displayName: 'authorize'

  propTypes:
    componentName: React.PropTypes.string.isRequired
    isGeneratingExtLink: React.PropTypes.bool.isRequired
    extLink: React.PropTypes.object
    refererUrl: React.PropTypes.string.isRequired
    generateExternalLinkFn: React.PropTypes.func.isRequired
    sendEmailFn: React.PropTypes.func.isRequired
    sendingLink: React.PropTypes.bool
    isExtLinkOnly: React.PropTypes.bool
    isInstantOnly: React.PropTypes.bool
    renderToForm: React.PropTypes.bool
    caption: React.PropTypes.string
    children: React.PropTypes.any


  getDefaultProps: ->
    isInstantOnly: false
    noConfig: false #if has kbc config
    caption: 'Authorize Google Account now'
    renderToForm: false


  getInitialState: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    token = ApplicationStore.getSapiTokenString()
    currentUserEmail = ApplicationStore.getCurrentAdmin().get 'email'
    component: ComponentsStore.getComponent(@props.componentName)
    configId: configId
    token: token
    currentUserEmail: currentUserEmail
    defaultActiveKey: if @props.isExtLinkOnly then 'external' else 'instant'


  render: ->
    if @props.renderToForm
      return @_renderToForm()

    div {className: 'container-fluid kbc-main-content'},
      TabbedArea defaultActiveKey: @state.defaultActiveKey, animation: false,
        if not @props.isExtLinkOnly
          TabPane eventKey: 'instant', tab: 'Instant Authorization',
            form {className: 'form-horizontal', action: @_getOAuthUrl(), method: 'POST'},
              div  className: 'row',
                div className: 'well',
                  @props.caption
                @_createHiddenInput('token', @state.token)
                @_createHiddenInput('account', @state.configId) if not @props.noConfig
                @_createHiddenInput('referrer', @_getReferrer())
                @_createHiddenInput('external', '1') if @props.noConfig
                Button
                  className: 'btn btn-primary'
                  type: 'submit',
                    @props.caption
        if not @props.isInstantOnly
          TabPane eventKey: 'external', tab: 'External Authorization',
            form {className: 'form-horizontal'},
              div className: 'row',
                div className: 'well',
                  'Generated external link allows to authorize the Google account \
                   without having an access to the KBC. The link is temporary valid and \
                   expires 48 hours after the generation.'
                @_renderExtLink() if @props.extLink
              div className: 'row',
                div className: 'kbc-buttons',
                  Button
                    className: 'btn btn-primary'
                    onClick: @_generateExternalLink
                    disabled: @props.isGeneratingExtLink
                    type: 'button',
                      if @props.extLink
                        'Regenerate External Link'
                      else
                        'Generate External Link'
                  span null,
                    ' '
                    Loader() if @props.isGeneratingExtLink



  _renderToForm: ->
    form {className: 'form-horizontal', action: @_getOAuthUrl(), method: 'POST'},
        @_createHiddenInput('token', @state.token)
        @_createHiddenInput('account', @state.configId) if not @props.noConfig
        @_createHiddenInput('referrer', @_getReferrer())
        @_createHiddenInput('external', '1') if @props.noConfig
        @props.children

        # Button
        #   className: 'btn btn-primary'
        #   type: 'submit',
        #     @props.caption

  _renderExtLink: ->
    div className: 'form-horizontal',
      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'External Authorization Link:'
        div className: 'col-sm-9',
          pre className: 'form-control-static', @props.extLink.get('link')
      if @props.sendEmailFn
        span null,
          Input
            wrapperClassName: 'col-sm-9'
            labelClassName: 'col-sm-3'
            label: 'Email Link To:'
            type: 'email'
            value: @state.email
            placeholder: 'email address of the recipient'
            onChange: (event) =>
              @setState
                email: event.target.value
          div className: 'form-group',
            label className: 'col-sm-3 control-label', 'Message(optional):'
            div className: 'col-sm-9',
              textarea
                className: 'form-control'
                value: @state.message
                placeholder: 'message for the link recipient'
                onChange: (event) =>
                  @setState
                    message: event.target.value
          div className: 'form-group',
            div className: 'col-sm-offset-3 col-sm-4',
              Button
                bsStyle: 'primary'
                disabled: not @state.email or @props.sendingLink
                onClick: =>
                  @props.sendEmailFn(
                    @state.currentUserEmail,
                    @state.email,
                    @state.message,
                    @props.extLink.get('link'))
              ,
                'Send Email '
              span null,
                ' '
                Loader() if @props.sendingLink


  _generateExternalLink: ->
    @props.generateExternalLinkFn()


  _getOAuthUrl: ->
    endpoint = @state.component.get('uri')
    oauthUrl = "#{endpoint}/oauth"
    return oauthUrl

  _getReferrer: ->
    return @props.refererUrl
    # {origin, pathname, search} = window.location
    # basepath = "#{origin}#{pathname}#{search}#/extractors/#{@props.componentName}"
    # referrer = "#{basepath}/#{@state.configId}/sheets"
    # return referrer #encodeURIComponent(referrer)

  _createHiddenInput: (name, value) ->
    input
      name: name
      type: 'hidden'
      value: value
