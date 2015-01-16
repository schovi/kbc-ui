React = require 'react'

module.exports = React.createClass
  displayName: 'Loader'
  render: ->
    React.DOM.span className: 'fa fa-spin fa-spinner'