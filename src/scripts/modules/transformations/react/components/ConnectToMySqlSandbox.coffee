React = require 'react'

Link = React.createFactory(require('react-router').Link)

{button, form, input, span} = React.DOM

ConnectToMySqlSandbox = React.createClass

  propTypes:
    credentials: React.PropTypes.object.isRequired

  displayName: 'ConnectToMySqlSandbox'

  render: ->
    form {method: 'post', action: 'https://adminer.keboola.com'},
      input {type: 'hidden', name: 'auth[driver]', value: 'server'}
      input {type: 'hidden', name: 'auth[server]', value: @props.credentials.get "hostname"}
      input {type: 'hidden', name: 'auth[username]', value: @props.credentials.get "user"}
      input {type: 'hidden', name: 'auth[db]', value: @props.credentials.get "db"}
      input {type: 'hidden', name: 'auth[password]', value: @props.credentials.get "password"}
      @props.children

module.exports = ConnectToMySqlSandbox
