React = require 'react'

ReactZeroClipboard =  React.createFactory(require 'react-zeroclipboard')

Clipboard = React.createClass
  displayName: 'Check'
  propTypes:
    text: React.PropTypes.string.isRequired

  render: ->
    component = @
    ReactZeroClipboard
      getText: -> component.props.text
    ,
      React.DOM.span
        className: 'fa fa-fw fa-copy'

module.exports = Clipboard
