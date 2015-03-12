React = require('react')
ComponentsStore = require '../../components/stores/ComponentsStore'
RoutesStore = require '../../../stores/RoutesStore'
ApplicationStore = require '../../../stores/ApplicationStore'
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
TabbedArea = React.createFactory(require('react-bootstrap').TabbedArea)
TabPane = React.createFactory(require('react-bootstrap').TabPane)
Button = React.createFactory(require('react-bootstrap').Button)
Input = React.createFactory(require('react-bootstrap').Input)
Loader = React.createFactory(require '../../../react/common/Loader')
{textarea, label, div, span, form, pre } = React.DOM

module.exports = React.createClass
  displayName: 'authorize'

  propTypes:
    componentName: React.PropTypes.string.isRequired
    isGeneratingExtLink: React.PropTypes.bool.isRequired
    extLink: React.PropTypes.string.isRequired
    refererUrl: React.PropTypes.string.isRequired
    generateExternalLinkFn: React.PropTypes.func.isRequired
    sendEmailFn: React.PropTypes.func.isRequired


  getInitialState: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    token = ApplicationStore.getSapiTokenString()
    component: ComponentsStore.getComponent(@props.componentName)
    configId: configId
    token: token


  render: ->
    div {className: 'container-fluid kbc-main-content'},
      TabbedArea defaultActiveKey: 'instant', animation: false,
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
                'Generated external link allows to authorize the Google account\
                 without having an access to the KBC. The link is temporary valid and \
                 expires 48 hours after the generation.'
              @_renderExtLink() if @props.extLink
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
    form className: 'form-horizontal',
      div className: 'pre',
      div className: 'form-group',
        label className: 'col-sm-12', 'External Authorization Link'
        div className: 'col-sm-12',
          pre className: 'form-control-static', @props.extLink.get('link')
        if @props.sendEmailFn
          div null,
            Input
              wrapperClassName: 'col-sm-9'
              labelClassName: 'col-sm-3'
              label: 'Email Link To:'
              className: 'form-control'
              type: 'text'
              value: @state.email
              placeholder: 'email address of the recipient'
              onChange: (event) =>
                @setState
                  email: event.target.value
            div className: 'form-group',
              label className: 'col-sm-3 control-label', 'Message:'
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
              onClick: =>
                @props.sendEmailFn(@state.email, @state.message)
            ,
              'Send Email'






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
