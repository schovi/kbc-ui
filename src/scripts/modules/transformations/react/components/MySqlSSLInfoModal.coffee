React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ModalHeader = React.createFactory(require('react-bootstrap/lib/ModalHeader'))
ModalBody = React.createFactory(require('react-bootstrap/lib/ModalBody'))
ModalFooter = React.createFactory(require('react-bootstrap/lib/ModalFooter'))
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

{p, a, h4} = React.DOM

MySqlSSLInfoModal = React.createClass
  displayName: 'MySqlSSLInfoModal'

  propTypes:
    onHide: React.PropTypes.func.isRequired
    show: React.PropTypes.bool.isRequired

  render: ->
    Modal {show: @props.show, title: "MySQL SSL Information", onHide: @props.onHide},
      ModalHeader {closeButton: true},
        h4 {},
          "MySQL SSL Connection"
      ModalBody null,
        p {},
          "To establish a secure connection to MySQL sandbox follow our "
          a {href: "https://sites.google.com/a/keboola.com/wiki/home/keboola-connection" +
            "/user-space/kbc-generic/ssl-connection-to-mysql-sandbox"},
            "wiki guide"
          "."
      ModalFooter null,
        ButtonToolbar null,
          Button
            onClick: @props.onHide
          ,
            'Close'

module.exports = MySqlSSLInfoModal
