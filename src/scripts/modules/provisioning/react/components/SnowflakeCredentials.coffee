React = require 'react'

Protected = React.createFactory(require('kbc-react-components').Protected)
Clipboard = React.createFactory(require('../../../../react/common/Clipboard').default)
Loader = React.createFactory(require('kbc-react-components').Loader)

{a, span, div, strong, small} = React.DOM

SnowflakeCredentials = React.createClass
  displayName: 'SnowflakeCredentials'
  propTypes:
    credentials: React.PropTypes.object
    isCreating: React.PropTypes.bool
  render: ->
    div {},
      if @props.isCreating
        span {},
          Loader()
          ' Creating sandbox'
      else
        if @props.credentials.get "id"
          @_renderCredentials()

        else
          'Sandbox not found'

  _renderCredentials: ->
    span {},
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Host'
        strong {className: 'col-md-9'},
          @props.credentials.get "hostname"
          Clipboard text: @props.credentials.get "hostname"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Port'
        strong {className: 'col-md-9'},
          '443'
          Clipboard text: '443'
      div {className: 'row'},
        span {className: 'col-md-3'}, 'User'
        strong {className: 'col-md-9'},
          @props.credentials.get "user"
          Clipboard text: @props.credentials.get "user"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Password'
        strong {className: 'col-md-9'},
          Protected {},
            @props.credentials.get "password"
          Clipboard text: @props.credentials.get "password"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Database'
        strong {className: 'col-md-9'},
          @props.credentials.get "db"
          Clipboard text: @props.credentials.get "db"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Schema'
        strong {className: 'col-md-9'},
          @props.credentials.get "schema"
          Clipboard text: @props.credentials.get "schema"
      #div {className: 'row'},
      #  span {className: 'col-md-3'}, 'Warehouse'
      #  strong {className: 'col-md-9'},
      #    @props.credentials.get "warehouse"
      #    Clipboard text: @props.credentials.get "warehouse"

module.exports = SnowflakeCredentials
