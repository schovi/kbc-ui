React = require 'react'
_ = require 'underscore'
#DropboxModal = React.createFactory require './DropboxModal'
{button, strong, div, h2, span, h4, section, p} = React.DOM
{OverlayTrigger, Tooltip, Button} = require 'react-bootstrap'
Button = React.createFactory(Button)
{Map} = require 'immutable'
Confirm = require '../../../../../react/common/Confirm'

module.exports = React.createClass
  displayName: 'TableauServerRow'

  propTypes:
    updateLocalStateFn: React.PropTypes.func
    localState: React.PropTypes.object
    configId: React.PropTypes.string
    account: React.PropTypes.object


  render: ->
    div {className: 'row'},
      @props.renderComponent()
