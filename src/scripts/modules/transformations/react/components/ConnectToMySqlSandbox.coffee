React = require 'react'

Link = React.createFactory(require('react-router').Link)

{button, form, input, span} = React.DOM

ConnectToMySqlSandbox = React.createClass

  propTypes:
    credentials: React.PropTypes.object

  displayName: 'ConnectToMySqlSandbox'

  render: ->
    form {method: 'post', action: 'https://adminer.keboola.com'},
      input {type: 'hidden', name: 'auth[driver]', value: 'server'}
      input {type: 'hidden', name: 'auth[server]', value: @props.credentials.getIn ["credentials", "hostname"]}
      input {type: 'hidden', name: 'auth[username]', value: @props.credentials.getIn ["credentials", "user"]}
      input {type: 'hidden', name: 'auth[db]', value: @props.credentials.getIn ["credentials", "db"]}
      input {type: 'hidden', name: 'auth[password]', value: @props.credentials.getIn ["credentials", "password"]}
      @props.children

module.exports = ConnectToMySqlSandbox
