React = require 'react'

module.exports = React.createClass
  displayName: 'ActiveCountBadge'
  propTypes:
    totalCount: React.PropTypes.number.isRequired
    activeCount: React.PropTypes.number.isRequired

  render: ->
    React.DOM.span className: 'badge',
      "#{@props.activeCount} / #{@props.totalCount}"