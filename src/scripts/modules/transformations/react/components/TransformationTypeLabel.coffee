React = require 'react'

{span} = React.DOM

TransformationTypeLabel = React.createClass
  displayName: 'TransformationTypeLabel'
  propTypes:
    backend: React.PropTypes.string.isRequired
    type: React.PropTypes.string
  render: ->
    if @props.backend == 'mysql' && @props.type == 'simple'
      span {className: 'label label-default'},
        'mysql'
    else if @props.backend == 'mysql'
      span {className: 'label label-default'},
        'mysql ' + @props.type
    else if @props.backend == 'redshift' && @props.type == 'simple'
      span {className: 'label label-success'},
        'redshift'
    else if @props.backend == 'remote'
      span {className: 'label label-danger'},
        'remote'
    else if @props.backend == 'docker' && @props.type == 'r'
      span {className: 'label label-danger'},
        'R'
    else if @props.backend == 'docker' && @props.type == 'python'
      span {className: 'label label-danger'},
        'Python'
    else if @props.backend == 'docker' && @props.type == 'openrefine'
      span {className: 'label label-danger'},
        'OpenRefine'
    else if @props.backend == 'snowflake'
      span {className: 'label label-info'},
        'snowflake'

    else
      null

module.exports = TransformationTypeLabel
