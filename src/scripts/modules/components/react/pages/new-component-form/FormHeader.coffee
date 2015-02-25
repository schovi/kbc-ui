React = require 'react'
ComponentIcon = React.createFactory(require '../../../../../react/common/ComponentIcon')
Button = React.createFactory(require('react-bootstrap').Button)

Loader = React.createFactory(require('../../../../../react/common/Loader'))

{div, h2, p, span} = React.DOM

module.exports = React.createClass
  displayName: 'FormHeader'
  propTypes:
    component: React.PropTypes.object.isRequired
    onSave: React.PropTypes.func.isRequired
    onCancel: React.PropTypes.func.isRequired
    isValid: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired

  render: ->
    div className: 'row kbc-header',
      div className: 'kbc-title',
        ComponentIcon
          component: @props.component
          className: 'pull-left'
        h2 null, @props.component.get 'name'
        p null, @props.component.get 'description'
      div className: 'kbc-buttons',
        if @props.isSaving
          span null,
            Loader()
            ' '
        Button
          bsStyle: 'link'
          disabled: @props.isSaving
          onClick: @props.onCancel
        ,
          'Cancel'
        Button
          bsStyle: 'success'
          disabled: !@props.isValid || @props.isSaving
          onClick: @props.onSave
        ,
          'Create'