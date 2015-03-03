React = require 'react'

{button, form, input, span, div, strong} = React.DOM

MySqlCredentials = React.createClass
  displayName: 'MySqlCredentials'
  propTypes:
    credentials: React.PropTypes.object
    linkToSandbox: React.PropTypes.bool

  linkToSandbox: ->
    if @props.linkToSandbox
      div {className: 'row'},
        span {className: 'col-md-3'}, ''
        strong {className: 'col-md-9'},
          form {method: 'post', action: 'https://adminer.keboola.com'},
            input {type: 'hidden', name: 'auth[driver]', value: 'server'}
            input {type: 'hidden', name: 'auth[server]', value: @props.credentials.getIn ["credentials", "hostname"]}
            input {type: 'hidden', name: 'auth[username]', value: @props.credentials.getIn ["credentials", "user"]}
            input {type: 'hidden', name: 'auth[db]', value: @props.credentials.getIn ["credentials", "db"]}
            input {type: 'hidden', name: 'auth[password]', value: @props.credentials.getIn ["credentials", "password"]}
            button {className: 'btn btn-primary', type: 'submit'}, 'Connect'
      
  render: ->
    div {},
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Host'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "hostname"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Port'
        strong {className: 'col-md-9'}, '3306'
      div {className: 'row'},
        span {className: 'col-md-3'}, 'User'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "user"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Password'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "password"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Database'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "db"]
      @linkToSandbox()

module.exports = MySqlCredentials
