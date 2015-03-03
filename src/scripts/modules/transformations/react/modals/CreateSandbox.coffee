React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

TransformationActionCreators = require '../../ActionCreators'

{div, p, strong, form, input, label, textarea} = React.DOM

CreateSandbox = React.createClass
  displayName: 'CreateSandbox'

  propTypes:
    backend: React.PropTypes.string.isRequired

  getInitialState: ->
    preserve: false
    backend: @props.backend
    include: ""
    exclude: ""
    rows: 0

  render: ->
    Modal title: "Create Sandbox", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        form className: 'form-horizontal',
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Backend'
            div className: 'col-sm-6',
              p className: 'form-control-static', @state.backend
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Include'
            div className: 'col-sm-6',
              input
                placeholder: 'Buckets or tables...'
                className: 'form-control'
                value: @state.include
                onChange: @_setInclude
                ref: 'include'
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Exclude'
            div className: 'col-sm-6',
              input
                placeholder: 'Buckets or tables...'
                className: 'form-control'
                value: @state.exclude
                onChange: @_setExclude
                ref: 'exclude'
          div className: 'form-group',
            label className: 'col-sm-4 control-label', 'Rows'
            div className: 'col-sm-6',
              input
                type: 'number'
                placeholder: 'Number of rows'
                className: 'form-control'
                value: @state.rows
                onChange: @_setRows
                ref: 'exclude'
          div className: 'form-group',
            label className: 'col-sm-4 control-label'
            div className: 'col-sm-6',
              label className: 'control-label',
                input
                  type: 'checkbox'
                  onChange: @_setPreserve
                  ref: 'preserve'
                'Preserve'
      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary', onClick: @_handleCreate,
            'Create'

  _setInclude: (e) ->
    include = e.target.value.trim()
    @setState
      include: include

  _setExclude: (e) ->
    exclude = e.target.value.trim()
    @setState
      exclude: exclude

  _setRows: (e) ->
    rows = e.target.value.trim()
    @setState
      rows: rows

  _setPreserve: (e) ->
    preserve = e.target.checked
    @setState
      preserve: preserve

  _handleCreate: ->
    TransformationActionCreators.createSandbox(
      backend: @state.backend
      preserve: @state.preserve
      rows: @state.rows
      include: @state.include
      exclude: @state.exclude
    ).then @props.onRequestHide

module.exports = CreateSandbox
