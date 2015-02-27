React = require 'react'

module.exports = React.createClass
  displayName: 'ActiveCountBadge'
  propTypes:
    totalCount: React.PropTypes.number.isRequired
    activeCount: React.PropTypes.number.isRequired

  render: ->
    className = if @props.activeCount > 0 then 'label-primary' else 'label-default'
    React.DOM.span className: 'label ' + className,
      "#{@props.activeCount} / #{@props.totalCount}"