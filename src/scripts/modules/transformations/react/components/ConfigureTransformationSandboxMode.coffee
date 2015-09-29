React = require 'react'
RadioGroup = React.createFactory(require('react-radio-group'))
MySqlCredentialsContainer = React.createFactory(require('./MySqlCredentialsContainer'))
RedshiftCredentialsContainer = React.createFactory(require('./RedshiftCredentialsContainer'))
MySqlSandboxCredentialsStore = require('../../../provisioning/stores/MySqlSandboxCredentialsStore')
ConnectToMySqlSandbox = React.createFactory(require '../components/ConnectToMySqlSandbox')
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

{Input} = require 'react-bootstrap'
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
          div {className: 'form-horizontal'},
            React.createElement Input,
              type: 'radio'
              wrapperClassName: 'col-sm-offset-1 col-sm-8'
              label: 'Load input tables only'
              value: 'input'
            React.createElement Input,
              type: 'radio'
              wrapperClassName: 'col-sm-offset-1 col-sm-8'
              label: 'Prepare transformation'
              help: 'Load input tables AND perform required transformations'
              value: 'prepare'
            React.createElement Input,
              type: 'radio'
              wrapperClassName: 'col-sm-offset-1 col-sm-8'
              label: 'Execute transformation without writing to Storage API'
              value: 'dry-run'
      div {},
        h3 {},
          "Redirect"
        div {className: 'form-horizontal'},
          React.createElement Input,
            type: 'checkbox'
            value: '1'
            wrapperClassName: 'col-sm-offset-1 col-sm-8'
            checked: @state.redirect
            onChange: @_setRedirect
            label: 'Show job detail'
      if @props.backend == 'redshift' or @props.backend == 'mysql'
        div className: 'clearfix',
          h3 {},
            "Credentials"
          div className: 'col-sm-offset-1 col-sm-10',
            if @props.backend == 'redshift'
              RedshiftCredentialsContainer {isAutoLoad: true}
            else if @props.backend == 'mysql'
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
