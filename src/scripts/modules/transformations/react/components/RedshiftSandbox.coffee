React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ComponentsStore = require('../../../components/stores/ComponentsStore')
RedshiftSandboxCredentialsStore = require('../../../provisioning/stores/RedshiftSandboxCredentialsStore')
CredentialsActionCreators = require('../../../provisioning/ActionCreators')
RedshiftCredentials = React.createFactory(require('../../../provisioning/react/components/RedshiftCredentials'))
ConfigureSandbox = React.createFactory(require '../components/ConfigureSandbox')
RunComponentButton = React.createFactory(require '../../../components/react/components/RunComponentButton')
DeleteButton = React.createFactory(require '../../../../react/common/DeleteButton')
Spinner = React.createFactory(require '../../../../react/common/Spinner')
StorageBucketsStore = require '../../../components/stores/StorageBucketsStore'
StorageTablesStore = require '../../../components/stores/StorageTablesStore'


{div, span, input, strong, form, button, h3, h4, i, button, small, ul, li, a} = React.DOM
RedshiftSandbox = React.createClass

  mixins: [createStoreMixin(RedshiftSandboxCredentialsStore, StorageBucketsStore, StorageTablesStore)]

  displayName: 'RedshiftSandbox'

  getStateFromStores: ->
    credentials: RedshiftSandboxCredentialsStore.getCredentials()
    pendingActions: RedshiftSandboxCredentialsStore.getPendingActions()
    isLoading: RedshiftSandboxCredentialsStore.getIsLoading()
    isLoaded: RedshiftSandboxCredentialsStore.getIsLoaded()
    tables: StorageTablesStore.getAll()
    buckets: StorageBucketsStore.getAll()

  _renderCredentials: ->
    if @state.credentials.get "id"
      span {},
        RedshiftCredentials {credentials: @state.credentials}
    else
      if @state.pendingActions.get "create"
        React.createElement Spinner
      else
        button {className: 'btn btn-success', onClick: @_createCredentials},
        'Create Redshift Credentials'

  _renderControlButtons: ->
    if @state.credentials.get "id"
      sandboxConfiguration = {}
      span {},
        RunComponentButton(
          title: "Load Tables in Redshift Sandbox"
          component: 'transformation'
          method: 'create-sandbox'
          mode: 'button'
          runParams: ->
            sandboxConfiguration
        ,
          ConfigureSandbox
            backend: 'redshift'
            tables: @state.tables
            buckets: @state.buckets
            onChange: (params) ->
              sandboxConfiguration = params
        )
        if @state.pendingActions.get 'refresh'
          button {className: "btn btn-link", disabled: true},
            React.createElement Spinner
        else
          button {className: "btn btn-link", title: 'Refresh privileges', onClick: @_refreshRedshiftCredentials},
          span {className: 'fa fa-refresh'}
        DeleteButton
          tooltip: 'Delete Redshift Sandbox'
          isPending: @state.pendingActions.get 'drop'
          confirm:
            title: 'Delete Redshift Sandbox'
            text: 'Do you really want to delete Redshift sandbox?'
            onConfirm: @_dropCredentials

  render: ->
    div {className: 'table kbc-table-border-vertical kbc-detail-table'},
      div {className: 'tr'},
        div {className: 'td'},
          div {className: 'row'},
            h4 {}, 'Redshift'
            div {className: 'pull-right'},
              @_renderControlButtons()
        div {className: 'td'},
          @_renderCredentials()

  _createCredentials: ->
    CredentialsActionCreators.createRedshiftSandboxCredentials()

  _dropCredentials: ->
    CredentialsActionCreators.dropRedshiftSandboxCredentials()

  _refreshRedshiftCredentials: ->
    CredentialsActionCreators.refreshRedshiftSandboxCredentials()


module.exports = RedshiftSandbox
