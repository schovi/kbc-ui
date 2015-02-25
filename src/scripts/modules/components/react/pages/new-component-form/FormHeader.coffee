React = require 'react'
ComponentIcon = React.createFactory(require '../../../../../react/common/ComponentIcon')
Button = React.createFactory(require('react-bootstrap').Button)

{div, h2, p} = React.DOM

module.exports = React.createClass
  displayName: 'FormHeader'
  propTypes:
    component: React.PropTypes.object.isRequired
    onCreate: React.PropTypes.func.isRequired
    onCancel: React.PropTypes.func.isRequired

  render: ->
    div className: 'row kbc-header',
      div className: 'kbc-title',
        ComponentIcon
          component: @props.component
          className: 'pull-left'
        h2 null, @props.component.get 'name'
        p null, @props.component.get 'description'
      div className: 'kbc-buttons',
        Button
          bsStyle: 'link'
          onClick: @props.onCancel
        ,
          'Cancel'
        Button
          bsStyle: 'success'
          onclick: @props.onCreate
        ,
          'Create'