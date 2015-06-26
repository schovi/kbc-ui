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
{textarea, label, div, span, form, pre } = React.DOM

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


  getInitialState: ->
    console.log "asda", @props.isExtLinkOnly
    configId = RoutesStore.getCurrentRouteParam('config')
    token = ApplicationStore.getSapiTokenString()
    currentUserEmail = ApplicationStore.getCurrentAdmin().get 'email'
    component: ComponentsStore.getComponent(@props.componentName)
    configId: configId
    token: token
    currentUserEmail: currentUserEmail
    defaultActiveKey: if @props.isExtLinkOnly then 'external' else 'instant'

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      TabbedArea defaultActiveKey: @state.defaultActiveKey, animation: false,
        if not @props.isExtLinkOnly
          TabPane eventKey: 'instant', tab: 'Instant Authorization',
            form {className: 'form-horizontal', action: @_getOAuthUrl(), method: 'POST'},
              div  className: 'row',
                div className: 'well',
                  'Authorize Google account now.',
                @_createHiddenInput('token', @state.token)
                @_createHiddenInput('account', @state.configId)
                @_createHiddenInput('referrer', @_getReferrer())
                Button
                  className: 'btn btn-primary'
                  type: 'submit',
                    'Authorize Google account now'

        TabPane eventKey: 'external', tab: 'External Authorization',
          form {className: 'form-horizontal'},
            div className: 'row',
              div className: 'well',
                'Generated external link allows to authorize the Google account \
                 without having an access to the KBC. The link is temporary valid and \
                 expires 48 hours after the generation.'
              @_renderExtLink() if @props.extLink
            div className: 'row',
              Button
                className: 'btn btn-primary'
                onClick: @_generateExternalLink
                disabled: @props.isGeneratingExtLink
                type: 'button',
                  if @props.extLink
                    'Regenerate External Link'
                  else
                    'Generate External Link'
              Loader() if @props.isGeneratingExtLink

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
            className: 'form-control'
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
          Button
            bsStyle: 'primary'
            className: 'col-sm-offset-3 col-sm-2'
            disabled: not @state.email or @props.sendingLink
            onClick: =>
              @props.sendEmailFn(
                @state.currentUserEmail,
                @state.email,
                @state.message,
                @props.extLink.get('link'))
          ,
            'Send Email'
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
    Input
      name: name
      type: 'hidden'
      value: value
