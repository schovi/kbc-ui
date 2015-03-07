React = require 'react'

module.exports = React.createClass
  displayName: 'Protected'

  getInitialState: ->
    isProtected: true

  render: ->
    if @state.isProtected
      React.DOM.span
        className: 'fa fa-fw fa-lock kbc-protected'
        title: 'Protected content, click to reveal'
        onClick: @_show
    else
      React.DOM.span {},
        @props.children

  _show: ->
    @setState
      isProtected: false
