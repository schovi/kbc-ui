React = require 'react'

{div, p} = React.DOM

LoadingPage = React.createClass
  displayName: 'LoadingPage'

  render: ->
    div className: 'container-fluid kbc-main-content',
      'Loading ...'

module.exports = LoadingPage