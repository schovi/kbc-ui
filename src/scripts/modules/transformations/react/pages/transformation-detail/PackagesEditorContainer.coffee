React = require 'react'
Immutable = require 'immutable'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
PackagesEditor = React.createFactory(require('./PackagesEditor'))
_ = require('underscore')

module.exports = React.createClass
  displayName: 'PackagesEditorContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    input: React.PropTypes.string.isRequired
    onChangeValue: React.PropTypes.func.isRequired
    onChangeInput: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired
    name: React.PropTypes.string.isRequired

  _handleOnChangeValue: (value) ->
    @props.onChangeValue(value)

  _handleOnChangeInput: (value) ->
    @props.onChangeInput(value)

  render: ->
    component = @
    React.DOM.div className: 'well',
      "These packages will be installed in the Docker container running the R script. "
      "Do not forget to load them using "
      React.DOM.code {}, "library()"
      "."
    PackagesEditor
      value: @props.value
      input: @props.input
      name: @props.name
      disabled: @props.disabled
      placeholder: "Add a package..."
      onChangeValue: @_handleOnChangeValue
      onChangeInput: @_handleOnChangeInput
