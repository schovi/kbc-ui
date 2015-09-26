React = require 'react'

{span} = React.DOM

TableBackendLabel = React.createClass
  displayName: 'TableBackendLabel'
  propTypes:
    backend: React.PropTypes.string

  render: ->
    if (@props.backend == 'mysql')
      span {className: 'label label-default'},
        'mysql'
    else if (@props.backend == 'redshift')
      span {className: 'label label-success'},
        'redshift'
    else
      span {}

module.exports = TableBackendLabel
