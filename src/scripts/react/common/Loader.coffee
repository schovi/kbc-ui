React = require 'react'

module.exports = React.createClass
  displayName: 'Loader'
  render: ->
    React.DOM.span className: 'fa fa-fw fa-spin fa-spinner'
