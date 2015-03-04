React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
CredentialsStore = require('../../../../provisioning/stores/CredentialsStore')
CredentialsActionCreators = require('../../../../provisioning/ActionCreators')
MySqlCredentials = require('../../../../provisioning/react/components/MySqlCredentials')
RedshiftCredentials = require('../../../../provisioning/react/components/RedshiftCredentials')
ConfigureSandbox = React.createFactory(require '../../components/ConfigureSandbox')
ConnectToMySqlSandbox = React.createFactory(require '../../components/ConnectToMySqlSandbox')
RunComponentButton = require '../../../../components/react/components/RunComponentButton'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)


{div, span, input, strong, form, button, h3, h4, i, button, small, ul, li, a} = React.DOM
Sandbox = React.createClass
  displayName: 'Sandbox'
  mixins: [createStoreMixin(CredentialsStore)]

  getInitialState: ->
    redshiftSandboxConfiguration: {}

  getStateFromStores: ->
    mySqlCredentials: CredentialsStore.getByBackendAndType("mysql", "sandbox")
    redshiftCredentials: CredentialsStore.getByBackendAndType("redshift", "sandbox")

  mySqlCredentials: ->
    if @state.mySqlCredentials
      return span {},
        MySqlCredentials {credentials: @state.mySqlCredentials}
    else
      return button {className: 'btn btn-success', onClick: @_createMySqlCredentials},
        'Create MySql Credentials'


  redshiftCredentials: ->
    if @state.redshiftCredentials
      return span {},
        RedshiftCredentials {credentials: @state.redshiftCredentials}
    else
      return button {className: 'btn btn-success', onClick: @_createRedshiftCredentials},
        'Create Redshift Credentials'

  mySqlControlButtons: ->
    if @state.mySqlCredentials
      sandboxConfiguration = {}
      span {},
        RunComponentButton(
          title: "Load Tables in MySQL Sandbox"
          body: ConfigureSandbox
            backend: 'mysql'
            onChange: (params) ->
              sandboxConfiguration = params
          component: 'transformation'
          method: 'create-sandbox'
          mode: 'button'
          runParams: ->
            sandboxConfiguration
        )
        ConnectToMySqlSandbox {credentials: @state.mySqlCredentials},
          button {className: "btn btn-link", title: 'Connect To Sandbox', type: 'submit'},
            span {className: 'fa fa-database'}
        button {className: 'btn btn-link', title: 'Delete sandbox', onClick: @_dropMySqlCredentials},
          span {className: 'kbc-icon-cup'}

  redshiftControlButtons: ->
    if @state.redshiftCredentials

      sandboxConfiguration = {}
      span {},
        RunComponentButton(
          title: "Load Tables in Redshift Sandbox"
          body: ConfigureSandbox
            backend: 'redshift'
            onChange: (params) ->
              sandboxConfiguration = params
          component: 'transformation'
          method: 'create-sandbox'
          mode: 'button'
          runParams: ->
            sandboxConfiguration
        )
        button {className: "btn btn-link", title: 'Refresh privileges', onClick: @_refreshRedshiftCredentials},
          span {className: 'fa fa-refresh'}
        button {className: "btn btn-link",  title: 'Delete sandbox', onClick: @_dropRedshiftCredentials},
          span {className: 'kbc-icon-cup'}

  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-12 kbc-main-content'},
        div {className: 'table kbc-table-border-vertical kbc-detail-table'},
          div {className: 'tr'},
            div {className: 'td'},
              div {className: 'row'},
                h4 {}, 'MySQL'
                div {className: 'pull-right'},
                  @mySqlControlButtons()
            div {className: 'td'},
              @mySqlCredentials()
        div {className: 'table kbc-table-border-vertical kbc-detail-table'},
          div {className: 'tr'},
            div {className: 'td'},
              div {className: 'row'},
                h4 {}, 'Redshift'
                div {className: 'pull-right'},
                  @redshiftControlButtons()
            div {className: 'td'},
              @redshiftCredentials()

  _createRedshiftCredentials: ->
    CredentialsActionCreators.createCredentials('redshift', 'sandbox')

  _refreshRedshiftCredentials: ->
    CredentialsActionCreators.createCredentials('redshift', 'sandbox')

  _dropRedshiftCredentials: ->
    CredentialsActionCreators.dropCredentials('redshift', @state.redshiftCredentials.getIn ["credentials", "id"])

  _createMySqlCredentials: ->
    CredentialsActionCreators.createCredentials('mysql', 'sandbox')

  _dropMySqlCredentials: ->
    CredentialsActionCreators.dropCredentials('mysql', @state.mySqlCredentials.getIn ["credentials", "id"])

module.exports = Sandbox
