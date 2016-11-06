React = require('react')
ApplicationStore = require '../../../../stores/ApplicationStore'
_ = require('underscore')
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Modal = React.createFactory(require('react-bootstrap').Modal)
Input = React.createFactory(require('react-bootstrap').Input)
RouterStore = require('../../../../stores/RoutesStore')

{i, span, div, p, strong, form, input, label, div} = React.DOM

module.exports = React.createClass
  displayName: "DropboxAuthorizeModal"

  propTypes:
    configId: React.PropTypes.string.isRequired
    redirectRouterPath: React.PropTypes.string
    credentialsId: React.PropTypes.string
    componentId: React.PropTypes.string

  getInitialState: ->
    oauthUrl = 'https://syrup.keboola.com/oauth/auth20'
    description: ""
    token: ApplicationStore.getSapiTokenString()
    oauthUrl: oauthUrl
    router: RouterStore.getRouter()

  getDefaultProps: ->
    redirectRouterPath: 'wr-dropbox-oauth-redirect'
    componentId: 'wr-dropbox'

  componentDidMount: ->
    @refs.description.getInputDOMNode().focus()

  render: ->
    Modal
      title: 'Authorize Dropbox Account'
      onRequestHide: @props.onRequestHide
    ,
        form
          className: 'form-horizontal'
          action: @state.oauthUrl
          method: 'POST'
          @_createHiddenInput('api', @props.componentId)
          @_createHiddenInput('id', @props.credentialsId or @props.configId)
          @_createHiddenInput('token', @state.token)
          @_createHiddenInput('returnUrl', @_getRedirectUrl())
        ,
          div className: 'modal-body',
            Input
              label: "Dropbox Email"
              type: 'text'
              ref: 'description'
              name: 'description'
              help: 'Used afterwards as a description of the authorized account'
              labelClassName: 'col-xs-3'
              wrapperClassName: 'col-xs-9'
              defaultValue: @state.desription
              onChange: (event) =>
                @setState
                  description: event.target.value

          div className: 'modal-footer',
            ButtonToolbar null,
              Button
                onClick: @props.onRequestHide
                bsStyle: 'link'
              ,
                'Cancel'
              Button
                bsStyle: 'success'
                type: 'submit'
                disabled: _.isEmpty(@state.description)
              ,
                span null,
                  i className: 'fa fa-fw fa-dropbox'
                  ' Authorize'

  _createHiddenInput: (name, value) ->
    input
      name: name
      type: 'hidden'
      value: value

  _getRedirectUrl: ->
    origin = ApplicationStore.getSapiUrl()
    url = @state.router.makeHref(@props.redirectRouterPath, config: @props.configId)
    projectUrl = ApplicationStore.getProjectBaseUrl()
    result = "#{origin}#{url}"
    result
