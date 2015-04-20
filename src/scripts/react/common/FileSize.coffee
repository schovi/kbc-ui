React = require 'react'
filesize = require 'filesize'

{span} = React.DOM

FileSize = React.createClass
  displayName: 'FileSize'
  propTypes:
    size: React.PropTypes.number

  render: ->
    span {},
      if (@props.size)
        filesize(@props.size)
      else
        'N/A'

module.exports = FileSize
