React = require 'react'
humanSize = require 'human-size'

{span} = React.DOM

FileSize = React.createClass
  displayName: 'FileSize'
  propTypes:
    size: React.PropTypes.number

  render: ->
    span {},
      if (@props.size)
        humanSize(@props.size)
      else
        'N/A'

module.exports = FileSize
