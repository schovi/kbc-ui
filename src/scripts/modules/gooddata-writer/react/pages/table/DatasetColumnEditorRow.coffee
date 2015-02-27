React = require 'react'

{tr, td} = React.DOM

Input = React.createFactory(require('react-bootstrap').Input)

pureRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

module.exports = React.createClass
  displayName: 'DatasetColumnEditorRow'
  mixins: [pureRendererMixin]
  propTypes:
    column: React.PropTypes.object.isRequired
    isEditing: React.PropTypes.bool.isRequired

  render: ->
    column = @props.column
    tr null,
      td null,
        column.get 'name'
      td null,
        Input
          type: if @props.isEditing then 'text' else 'static'
          value: column.get 'gdName'
          disabled: !@props.isEditing
      td null
      td null
      td null
      td null
      td null

