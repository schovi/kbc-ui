React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Select = React.createFactory(require('react-select'))
_ = require('underscore')
Immutable = require('immutable')

module.exports = React.createClass
  displayName: 'SelectRequires'
  mixins: [ImmutableRenderMixin]

  propTypes:
    name: React.PropTypes.string.isRequired
    value: React.PropTypes.object.isRequired
    transformations: React.PropTypes.object.isRequired
    transformation: React.PropTypes.object.isRequired
    phase: React.PropTypes.number.isRequired
    disabled: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired

  render: ->
    props = @props
    Select
      name: @props.name
      value: @props.value.toArray()
      multi: true
      options: (->
        _.sortBy(
          _.map(
            _.filter(props.transformations.toArray(), (transformation) ->
              transformation.get("phase") == props.phase && transformation.get("id") != props.transformation.get("id")
            ), (transformation) -> {
              label: transformation.get("name")
              value: transformation.get("id")
            }
          ), (option) ->
            option.label.toLowerCase()
      ))()

      delimiter: ','
      onChange: (string, array) ->
        props.onChange(Immutable.fromJS(_.pluck(array, 'value')))
      placeholder: 'Select transformations...'
      disabled: @props.disabled
