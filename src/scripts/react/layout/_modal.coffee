React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
Input = React.createFactory(require('react-bootstrap').Input)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)

{div, form, input, option} = React.DOM

module.exports = React.createClass
  displayName: 'NewProjectModal'
  propTypes:
    xsrf: React.PropTypes.string.isRequired
    organizations: React.PropTypes.object.isRequired
    urlTemplates: React.PropTypes.object.isRequired
    projectTemplates: React.PropTypes.object.isRequired

  getInitialState: ->
    name: ''
    isSaving: false

  componentDidMount: ->
    @refs.name.getInputDOMNode().focus()

  render: ->
    Modal title: "New Project", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        form
          className: 'form-horizontal'
          ref: 'projectCreateForm'
          method: 'post'
          action: @props.urlTemplates.get 'createProject'
        ,
          Input
            label: 'Name'
            name: 'name'
            ref: 'name'
            value: @state.name
            onChange: @_handleNameChange
            type: 'text'
            placeholder: 'My Project'
            labelClassName: 'col-sm-4'
            wrapperClassName: 'col-sm-6'
          Input
            label: 'Organization'
            name: 'organizationId'
            type: 'select'
            labelClassName: 'col-sm-4'
            wrapperClassName: 'col-sm-6'
          ,
            @props.organizations.map (organization) ->
              option
                value: organization.get('id')
                key: organization.get('id')
              ,
                organization.get 'name'
            .toArray()
          input
            type: 'hidden'
            name: 'xsrf'
            value: @props.xsrf


      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide, bsStyle: 'link',
            'Cancel'
          Button
            bsStyle: 'primary'
            onClick: @_handleCreate
            disabled: !@_isValid() || @state.isSaving
          ,
            'Create Project'

  _handleNameChange: (e) ->
    @setState
      name: e.target.value

  _isValid: ->
    @state.name != ''

  _handleCreate: ->
    @setState
      isSaving: true
    @refs.projectCreateForm.getDOMNode().submit()
