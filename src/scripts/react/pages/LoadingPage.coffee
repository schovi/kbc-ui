React = require 'react'

{div, span} = React.DOM

LoadingPage = React.createClass
  displayName: 'LoadingPage'

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'kbc-main-loader',
        span className: 'fa fa-spin fa-spinner'
        span null, 'Loading ...'

module.exports = LoadingPage