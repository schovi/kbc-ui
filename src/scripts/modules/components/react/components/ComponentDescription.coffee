React = require 'react'
createComponentEditClass = require './ComponentEditField'
InlineEditTextArea = require '../../../../react/common/InlineEditArea'
ComponentEditField = require './ComponentEditField'

module.exports = React.createClass
  displayName: 'ComponentDescription'
  propTypes:
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired
  render: ->
    React.createElement ComponentEditField,
      componentId: @props.componentId
      configId: @props.configId
      fieldName: 'description'
      editElement: InlineEditTextArea
      placeholder: 'Describe the configuration...'


