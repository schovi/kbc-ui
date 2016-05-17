React = require 'react'
_ = require 'underscore'

Textarea = require 'react-textarea-autosize'
{Input} = require 'react-bootstrap'
{form, div, label, p, a, label} = React.DOM
TestCredentials = require './TestCredentialsButtonGroup'
{NewLineToBr, Check} = require('kbc-react-components')

_helpUrl = 'https://sites.google.com/a/keboola.com/wiki/home/keboola-connection/ui-articles/-db-ex-ssl-credentials'

module.exports = React.createClass
  displayName: 'SSLForm'
  propTypes:
    credentials: React.PropTypes.object.isRequired
    enabled: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func
    componentId: React.PropTypes.string.isRequired
    actionsProvisioning: React.PropTypes.object.isRequired

  getDefaultProps: ->
    onChange: ->

  _handleChange: (propName, event) ->
    @props.onChange(@props.credentials.setIn ['ssl', propName], event.target.value)

  _handleToggle: (propName, event) ->
    @props.onChange(@props.credentials.setIn ['ssl', propName], event.target.checked)

  _isSSLEnabled: ->
    @props.credentials.getIn ['ssl', 'enabled']

  render: ->
    form null,
      div className: 'row',
        div className: 'well',
          'MySQL database extractor supports secure (encrypted) connections
            between MySQL clients and the server using SSL.
            Provide set of SSL certificates to configure the secure connection. Read more on '
          a href: _helpUrl,
            "How to Configure MySQL server - DB Admin's article."
      div className: 'row',
        @_createEnableSSLCheckbox 'enabled'
      if @_isSSLEnabled()
        div className: 'row',
          @_createInput 'SSL Client Certificate (client-cert.pem)', 'cert'
          @_createInput 'SSL Client Key (client-key.pem)', 'key'
          @_createInput 'SSL CA Certificate (ca-cert.pem)', 'ca'
          @_createInput 'SSL Cipher',
            'cipher',
            'You can optionally provide a list of permissible ciphers to use for SSL encryption.'
          React.createElement TestCredentials,
            credentials: @props.credentials
            hasOffset: false
            componentId: @props.componentId
            actionsProvisioning: @props.actionsProvisioning


  _createEnableSSLCheckbox: (propName) ->
    if @props.enabled
      div className: 'form-group',
        React.createElement Input,
          label: 'Enable encrypted connection'
          type: 'checkbox'
          onChange: @_handleToggle.bind @, propName
          checked: @_isSSLEnabled()
    else
      div className: 'form-horizontal',
        div className: 'form-group',
          label className: 'control-label col-xs-4',
            'Encrypted connection'
          div null,
            p className: 'form-control-static col-xs-8',
              React.createElement Check,
                isChecked: @_isSSLEnabled()

  _createInput: (labelValue, propName, help = null) ->
    if @props.enabled
      div className: 'form-group',
        label className: 'control-label',
          labelValue
        if help
          p className: 'help-block',
            help
        React.createElement Textarea,
          label: labelValue
          type: 'textarea'
          value: @props.credentials.getIn ['ssl', propName]
          onChange: @_handleChange.bind @, propName
          className: 'form-control'
          minRows: 4
    else
      @_createStaticControl labelValue, propName

  _createStaticControl: (labelValue, propName) ->
    div className: 'form-group',
      label className: 'control-label',
        labelValue
      div null,
        p className: 'form-control-static',
          if @props.credentials.getIn(['ssl', propName])
            React.createElement NewLineToBr, text: @props.credentials.getIn(['ssl', propName])
          else
            'Not set.'
