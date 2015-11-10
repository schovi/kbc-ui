React = require 'react'
FormHeader = React.createFactory(require './FormHeader')
Button = React.createFactory(require('react-bootstrap').Button)
contactSupport = require('../../../../../utils/contactSupport').default

{div, form, p} = React.DOM

module.exports = React.createClass
  displayName: 'ManualConfigurationForm'
  propTypes:
    component: React.PropTypes.object.isRequired
    configuration: React.PropTypes.object.isRequired
    onCancel: React.PropTypes.func.isRequired

  render: ->
    form className: 'form-horizontal',
      FormHeader
        component: @props.component
        withButtons: false
      div className: 'row',
        div className: 'col-xs-4',
          p null, @_text()
          div className: 'kbc-buttons',
            Button
              bsStyle: 'success'
              onClick: @_contactSupport
            ,
              'Contact Support'
            Button
              bsStyle: 'link'
              onClick: @props.onCancel
            ,
              'Back'

  _text: ->
    switch @props.component.get 'type'
      when 'writer' then 'This writer has to be configured manually, please contact our support for assistance.'
      when 'extractor' then 'This extractor has to be configured manually,
       please contact our support for assistance.'

  _contactSupport: ->
    contactSupport(
      subject: "#{@props.component.get('name')} #{@props.component.get('type')}
        configuration assistance request"
      type: "project"
    )

