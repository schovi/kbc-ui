React = require 'react'

FormHeader = React.createFactory(require './FormHeader')

{div, form} = React.DOM



module.exports = React.createClass
  displayName: 'NewComponentDefaultForm'
  propTypes:
    component: React.PropTypes.object.isRequired

  render: ->
    form className: 'form-horizontal',
      FormHeader
        component: @props.component
