React = require 'react'

Router = require 'react-router'

{button, span, i} = React.DOM


TransformationTypeLabel = React.createClass
  displayName: 'TransformationTypeLabel'
  propTypes:
    backend: React.PropTypes.string.isRequired
    type: React.PropTypes.string

  render: ->
    if @props.backend == 'db' && @props.type == 'simple'
      span {className: 'label label-default'},
        'mysql'
    else if @props.backend == 'db'
      span {className: 'label label-default'},
        'mysql ' + @props.type
    else if @props.backend == 'redshift' && @props.type == 'simple'
      span {className: 'label label-success'},
        'redshift'
    else if @props.backend == 'remote'
      span {className: 'label label-danger'},
        'remote'
    else if @props.backend == 'docker' && @props.type == 'r'
      span {className: 'label label-info'},
        'R'

module.exports = TransformationTypeLabel
