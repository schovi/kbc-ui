React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
RadioGroup = React.createFactory(require('react-radio-group'))
_ = require('underscore')

{div, p, h4, strong, form, input, label, textarea, span} = React.DOM

ConfigureTransformationSandbox = React.createClass
  displayName: 'ConfigureTransformationSandbox'

  propTypes:
    bucketId: React.PropTypes.string.isRequired
    transformationId: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired

  getInitialState: ->
    configBucketId: @props.bucketId
    transformations: [@props.transformationId]
    mode: 'prepare'

  render: ->
    RadioGroup
      name: 'mode'
      value: @state.mode
      onChange: @_setMode
    ,
      form {className: 'form-horizontal'},
        div {className: 'radio'},
          label {},
            input
              type: 'radio'
              value: 'input'
            ,
              'Load input tables only'
        div {className: 'radio'},
          label {className: 'radio'},
            input
              type: 'radio'
              value: 'prepare'
            ,
              'Prepare transformation'
              span {className: 'help-block'},
                'Load input tables AND perform required transformations'
        div {className: 'radio'},
          label {className: 'radio'},
            input
              type: 'radio'
              value: 'dry-run'
            ,
              'Execute transformation without writing to Storage API'

  _setMode: (e) ->
    mode = e.target.value
    @setState
      mode: mode
    ,
      ->
        @props.onChange(@state)

module.exports = ConfigureTransformationSandbox
