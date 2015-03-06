React = require('react')
Immutable = require('immutable')

MySqlSandbox = React.createFactory(require '../../components/MySqlSandbox')
RedshiftSandbox = React.createFactory(require '../../components/RedshiftSandbox')

{div} = React.DOM
Sandbox = React.createClass
  displayName: 'Sandbox'

  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-12 kbc-main-content'},
        MySqlSandbox {}
        RedshiftSandbox {}

module.exports = Sandbox
