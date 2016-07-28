React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Select = require('react-select')
_ = require('underscore')
Immutable = require('immutable')
ConfirmButtons = require '../../../../../react/common/ConfirmButtons'

module.exports = React.createClass
  displayName: 'SelectRequires'
  mixins: [ImmutableRenderMixin]

  propTypes:
    requires: React.PropTypes.object.isRequired
    transformations: React.PropTypes.object.isRequired
    transformation: React.PropTypes.object.isRequired
    isSaving: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired

  render: ->
    props = @props
    React.DOM.div className: 'well',
      React.DOM.div className: 'help-block',
        "These transformations are processed before this transformation starts."
      React.DOM.div className: 'form-group',
        React.createElement Select,
          name: 'requires'
          value: @props.requires.toArray()
          multi: true
          options: (@getSelectOptions(@props.transformations, @props.transformation))
          delimiter: ','
          onChange: (string, array) ->
            props.onChange(Immutable.fromJS(_.pluck(array, 'value')))
          placeholder: 'Select transformations...'
          disabled: @props.isSaving
      React.createElement ConfirmButtons,
        isSaving: @props.isSaving
        onSave: @props.onSave
        onCancel: @props.onCancel
        placement: 'left'

  getSelectOptions: (transformations, currentTransformation) ->
    _.sortBy(
      _.map(
        _.filter(transformations.toArray(), (transformation) ->
          parseInt(transformation.get("phase")) == parseInt(currentTransformation.get("phase")) &&
            transformation.get("backend") == currentTransformation.get("backend") &&
            transformation.get("id") != currentTransformation.get("id")
        ), (transformation) -> {
          label: transformation.get("name")
          value: transformation.get("id")
        }
      ), (option) ->
        option.label.toLowerCase()
    )
