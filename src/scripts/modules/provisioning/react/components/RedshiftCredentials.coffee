React = require 'react'

Protected = React.createFactory(require '../../../../react/common/Protected')
Clipboard = React.createFactory(require '../../../../react/common/Clipboard')

{span, div, strong} = React.DOM

RedshiftCredentials = React.createClass
  displayName: 'RedshiftCredentials'
  propTypes:
    credentials: React.PropTypes.object

  render: ->
    div {},
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Host'
        strong {className: 'col-md-9'},
          @props.credentials.get "hostname"
          Clipboard text: @props.credentials.get "hostname"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Port'
        strong {className: 'col-md-9'},
          '5439'
          Clipboard text: '5439'
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

module.exports = RedshiftCredentials
