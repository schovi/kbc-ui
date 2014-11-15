React = require 'react'

Header = React.createClass
  displayName: 'Header'
  render: ->
    React.DOM.div {}, @props.name


module.exports = Header