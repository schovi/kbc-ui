React = require 'react'

module.exports = React.createClass
  displayName: 'Loader'
  render: ->
    className = if @props.className then @props.className else ''
    React.DOM.span className: "fa fa-spin fa-spinner #{className}"
