React = require 'react'

Check = React.createClass
  displayName: 'Check'
  propTypes:
    isChecked: React.PropTypes.bool.isRequired

  render: ->
    React.DOM.i
      className: if @props.isChecked then 'fa fa-fw fa-check' else 'fa fa-fw fa-times'

module.exports = Check