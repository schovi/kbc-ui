React = require 'react'
RadioGroup = React.createFactory(require('react-radio-group'))
MySqlCredentialsContainer = React.createFactory(require('./MySqlCredentialsContainer'))
RedshiftCredentialsContainer = React.createFactory(require('./RedshiftCredentialsContainer'))
MySqlSandboxCredentialsStore = require('../../../provisioning/stores/MySqlSandboxCredentialsStore')
ConnectToMySqlSandbox = React.createFactory(require '../components/ConnectToMySqlSandbox')
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

{div, p, strong, form, input, label, span, h3, h4, button} = React.DOM

ConfigureTransformationSandboxMode = React.createClass
  displayName: 'ConfigureTransformationSandboxMode'
  mixins: [createStoreMixin(MySqlSandboxCredentialsStore)]

  getStateFromStores: ->
    mysqlCredentials: MySqlSandboxCredentialsStore.getCredentials()

  propTypes:
    onChange: React.PropTypes.func.isRequired
    mode: React.PropTypes.string.isRequired
    backend: React.PropTypes.string.isRequired
    redirect: React.PropTypes.bool.isRequired

  getInitialState: ->
    mode: @props.mode
    redirect: @props.redirect

  render: ->
    div {},
      div {},
        h3 {},
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
      div {},
        h3 {},
          "Redirect"
        form {className: 'form-horizontal'},
          div {className: 'checkbox'},
            label {},
              input
                type: 'checkbox'
                value: '1'
                checked: @state.redirect
                onChange: @_setRedirect
              ,
                'Show job detail'
      div {},
        h3 {},
          "Credentials"
        if @props.backend == 'redshift'
          RedshiftCredentialsContainer {isAutoLoad: true}
        else
          span {},
            div {className: 'row'},
              div {className: 'col-md-9'},
                MySqlCredentialsContainer {isAutoLoad: true}
              div {className: 'col-md-3'},
                if @state.mysqlCredentials.get("id")
                  ConnectToMySqlSandbox {credentials: @state.mysqlCredentials},
                    button {className: "btn btn-link", title: 'Connect To Sandbox', type: 'submit'},
                      span {className: 'fa fa-fw fa-database'}
                      " Connect"


  _setRedirect: (e) ->
    redirect = e.target.checked
    @setState
      redirect: redirect
    ,
      ->
        @_propagateChanges()

  _setMode: (e) ->
    mode = e.target.value
    @setState
      mode: mode
    ,
      ->
        @_propagateChanges()

  _propagateChanges: ->
    @props.onChange
      mode: @state.mode
      redirect: @state.redirect


module.exports = ConfigureTransformationSandboxMode
