React = require 'react'
RadioGroup = React.createFactory(require('react-radio-group'))
MySqlCredentialsContainer = React.createFactory(require('./MySqlCredentialsContainer'))
RedshiftCredentialsContainer = React.createFactory(require('./RedshiftCredentialsContainer'))

{div, p, strong, form, input, label, span, h4} = React.DOM

ConfigureTransformationSandboxMode = React.createClass
  displayName: 'ConfigureTransformationSandboxMode'

  propTypes:
    onChange: React.PropTypes.func.isRequired
    mode: React.PropTypes.string.isRequired
    backend: React.PropTypes.string.isRequired

  getInitialState: ->
    mode: @props.mode

  render: ->
    div {},
      div {},
        h4 {},
          "Credentials"
        if @props.backend == 'redshift'
          RedshiftCredentialsContainer {isAutoLoad: true}
        else
          MySqlCredentialsContainer {isAutoLoad: true}
      div {},
        h4 {},
          "Mode"
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
        @props.onChange(@state.mode)

module.exports = ConfigureTransformationSandboxMode
