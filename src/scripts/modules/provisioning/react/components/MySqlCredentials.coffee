React = require 'react'

{span, div, strong} = React.DOM

MySqlCredentials = React.createClass
  displayName: 'MySqlCredentials'
  propTypes:
    credentials: React.PropTypes.object

  render: ->
    console.log "mysql credentials", @props.credentials
    div {},
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Host'
        strong {className: 'col-md-9'}, @props.credentials.get "hostname"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Port'
        strong {className: 'col-md-9'}, '3306'
      div {className: 'row'},
        span {className: 'col-md-3'}, 'User'
        strong {className: 'col-md-9'}, @props.credentials.get "user"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Password'
        strong {className: 'col-md-9'}, @props.credentials.get "password"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Database'
        strong {className: 'col-md-9'}, @props.credentials.get "db"

module.exports = MySqlCredentials
