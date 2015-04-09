React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
ItemsListEditor = require '../../../../../react/common/ItemsListEditor'


module.exports = React.createClass
  displayName: 'PackagesEditor'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired
    input: React.PropTypes.string
    onChangeValue: React.PropTypes.func.isRequired
    onChangeInput: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  render: ->
    React.createElement ItemsListEditor, @props
