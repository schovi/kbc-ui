React = require 'react'

{span} = React.DOM

TransformationTableTypeLabel = React.createClass
  displayName: 'TransformationTableTypeLabel'
  propTypes:
    backend: React.PropTypes.string.isRequired
    type: React.PropTypes.string

  render: ->
    if (@props.backend == 'docker')
      span {className: 'fa fa-file-text-o fa-fw', title: 'File'}
    else
      span {className: 'fa fa-table fa-fw', title: 'Table'}

module.exports = TransformationTableTypeLabel
