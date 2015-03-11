React = require 'react'

module.exports = React.createClass
  displayName: 'Spinner'
  render: ->
    React.DOM.span className: 'fa fa-refresh fa-fw fa-spin'
