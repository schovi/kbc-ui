React = require 'react'
Loader = React.createFactory(require '../common/Loader')

{div, span} = React.DOM



LoadingPage = React.createClass
  displayName: 'LoadingPage'

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'kbc-main-loader',
        Loader {}
        span null, 'Loading ...'

module.exports = LoadingPage
