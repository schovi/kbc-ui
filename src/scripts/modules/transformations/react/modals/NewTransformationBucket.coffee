React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

TransformationActionCreators = require '../../ActionCreators'

{div, p, strong, form, input, label, textarea} = React.DOM

NewTransformationBucket = React.createClass
  displayName: 'NewTransformationBucket'

  componentDidMount: ->
    @refs.name.getDOMNode().focus()

  getInitialState: ->
    isLoading: false
    isValid: false
    name: ''
    description: ''

  render: ->
    Modal title: "New Transformation Bucket", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        form className: 'form-horizontal',
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Name'
            div className: 'col-sm-6',
              input
                placeholder: 'Transformation bucket name'
                className: 'form-control'
                value: @state.text
                onChange: @_setName
                ref: 'name'
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Description'
            div className: 'col-sm-6',
              textarea
                placeholder: 'Bucket description'
                className: 'form-control'
                value: @state.description
                onChange: @_setDescription
                ref: 'description',
      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary', onClick: @_handleCreate, disabled: @state.isLoading || !@state.isValid,
            'Create'

  _handleCreate: ->
    @setState
      isLoading: true

    TransformationActionCreators.createTransformationBucket(
      name: @state.name
      description: @state.description
    ).then @props.onRequestHide

  _setName: (e) ->
    name = e.target.value.trim()
    @setState
      name: name
    @_validate()

  _setDescription: (e) ->
    description = e.target.value.trim()
    @setState
      description: description
    @_validate()
      
  _validate: ->
    if @state.description.length > 0 && @state.name.length > 0
      @setState
        isValid: true
    else
      @setState
        isValid: false

module.exports = NewTransformationBucket