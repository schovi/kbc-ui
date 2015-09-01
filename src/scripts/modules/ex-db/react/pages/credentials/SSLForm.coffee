React = require 'react'
_ = require 'underscore'

Textarea = require 'react-textarea-autosize'
{Input} = require 'react-bootstrap'
{form, div, label, p, a, label} = React.DOM
TestCredentials = require './TestCredentialsButtonGroup'

_helpUrl = 'https://sites.google.com/a/keboola.com/wiki/home/keboola-connection/ui-articles/-db-ex-ssl-credentials'

module.exports = React.createClass
  displayName: 'SSLForm'
  propTypes:
    credentials: React.PropTypes.object.isRequired
    enabled: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func

  getDefaultProps: ->
    onChange: ->

  _handleChange: (propName, event) ->
    @props.onChange(@props.credentials.setIn ['ssl', propName], event.target.value)

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
        @_createInput 'SSL Client Certificate (client-cert.pem)', 'cert'
        @_createInput 'SSL Client Key (client-key.pem)', 'key'
        @_createInput 'SSL CA Certificate (ca-cert.pem)', 'ca'
        React.createElement TestCredentials,
          credentials: @props.credentials
          hasOffset: false


  _createInput: (labelValue, propName) ->
    if @props.enabled
      div className: 'form-group',
        label className: 'control-label',
          labelValue
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
            @props.credentials.getIn(['ssl', propName])
          else
            'Not set.'
