React = require 'react'
_ = require 'underscore'
{List} = require 'immutable'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Button = React.createFactory(require('react-bootstrap').Button)
{Loader} = require('kbc-react-components')
Markdown = React.createFactory(require('./Markdown').default)
Textarea = require 'react-textarea-autosize'

{div, span, textarea, button, a} = React.DOM

StaticArea = React.createFactory React.createClass
  displayName: 'InlineEditAreaStatic'
  propTypes:
    text: React.PropTypes.string
    placeholder: React.PropTypes.string
    editTooltip: React.PropTypes.string
    onCancel: React.PropTypes.func

  render: ->
    props = _.omit @props, 'text'
    # props.className = 'kbc-inline-edit-link-markdown'
    span null,
      div props,
        if @props.text
          [
            OverlayTrigger
              overlay: Tooltip null, @props.editTooltip
              placement: 'top'
            ,
              div className: 'pull-right',
                button className: 'btn btn-link',
                  span className: 'kbc-icon-pencil'
            div null,
              Markdown
                source: @props.text
                escapeHtml: true
          ]
        else
          OverlayTrigger
            overlay: Tooltip null, @props.editTooltip
            placement: 'top'
          ,
            div className: 'text-right',
              button className: 'btn btn-link',
                span className: 'kbc-icon-pencil'
                ' '
                @props.placeholder



EditArea = React.createFactory React.createClass
  displayName: 'InlineEditAreaEdit'
  propTypes:
    text: React.PropTypes.string
    isSaving: React.PropTypes.bool
    placeholder: React.PropTypes.string
    onCancel: React.PropTypes.func
    onSave: React.PropTypes.func
    onChange: React.PropTypes.func

  _onChange: (e) ->
    @props.onChange e.target.value

  componentDidMount: ->
    @refs.textArea.focus()

  render: ->
    div className: 'form-inline kbc-inline-edit kbc-inline-textarea',
      React.createElement Textarea,
        ref: 'textArea'
        value: @props.text
        disabled: @props.isSaving
        placeholder: @props.placeholder
        onChange: @_onChange
        className: 'form-control'
        rows: 2
      span className: 'kbc-inline-edit-buttons',
        if @props.isSaving
          span null,
            React.createElement Loader
            ' '
        Button
          className: 'kbc-inline-edit-cancel'
          bsStyle: 'link'
          disabled: @props.isSaving
          onClick: @props.onCancel
        ,
          span className: 'kbc-icon-cross'
        Button
          className: 'kbc-inline-edit-submit'
          bsStyle: 'info'
          disabled: @props.isSaving
          onClick: @props.onSave
        ,
          'Save'
      span className: 'small help-block',
        a href: 'https://blog.ghost.org/markdown/',
          'Markdown'
        ' is supported'



module.exports = React.createClass
  displayName: 'InlineEditArea'
  propTypes:
    onEditStart: React.PropTypes.func.isRequired
    onEditCancel: React.PropTypes.func.isRequired
    onEditChange: React.PropTypes.func.isRequired
    onEditSubmit: React.PropTypes.func.isRequired
    text: React.PropTypes.string
    isSaving: React.PropTypes.bool
    isEditing: React.PropTypes.bool
    editTooltip: React.PropTypes.string
    placeholder: React.PropTypes.string

  getDefaultProps: ->
    placeholder: 'Click to edit'
    editTooltip: 'Click to edit'
    isSaving: false

  render: ->
    if @props.isEditing
      EditArea
        text: @props.text
        isSaving: @props.isSaving
        placeholder: @props.placeholder
        onChange: @props.onEditChange
        onCancel: @props.onEditCancel
        onSave: @props.onEditSubmit
    else
      StaticArea
        text: @props.text
        editTooltip: @props.editTooltip
        placeholder: @props.placeholder
        onClick: @props.onEditStart

