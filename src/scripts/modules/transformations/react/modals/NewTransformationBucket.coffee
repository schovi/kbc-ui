React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ConfirmButtons = React.createFactory(require '../../../../react/common/ConfirmButtons')

TransformationActionCreators = require '../../ActionCreators'

{div, p, strong, form, input, label, textarea} = React.DOM

module.exports = React.createClass
  displayName: 'NewTransformationBucket'

  componentDidMount: ->
    @refs.name.getDOMNode().focus()

  getInitialState: ->
    isLoading: false
    name: ''
    description: ''

  render: ->
    Modal title: "New Transformation Bucket", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        form className: 'form-horizontal',
          p className: 'help-block',
            'Transformation bucket is a container for related transformations.'
            ' '
            'When the bucket is created you can start creating transformations inside it'
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Name'
            div className: 'col-sm-6',
              input
                placeholder: 'Main'
                className: 'form-control'
                value: @state.text
                onChange: @_setName
                ref: 'name'
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Description'
            div className: 'col-sm-6',
              textarea
                placeholder: 'Main transformations'
                className: 'form-control'
                value: @state.description
                onChange: @_setDescription
                ref: 'description',
      div className: 'modal-footer',
        ConfirmButtons
          isSaving: @state.isLoading
          isDisabled: !@_isValid()
          saveLabel: 'Create'
          onCancel: @props.onRequestHide
          onSave: @_handleCreate

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

  _setDescription: (e) ->
    description = e.target.value
    @setState
      description: description

  _isValid: ->
    @state.name.length > 0