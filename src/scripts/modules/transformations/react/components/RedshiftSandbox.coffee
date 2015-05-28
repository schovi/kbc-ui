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
Loader = React.createFactory(require('kbc-react-components').Loader)
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
    span {},
      if @state.credentials.get "id"
        RedshiftCredentials {credentials: @state.credentials}
      else
        'Credentials not found'

  _renderControlButtons: ->
    if @state.credentials.get "id"
      sandboxConfiguration = {}
      div {},
        div {},
          RunComponentButton(
            title: "Load Tables in Redshift Sandbox"
            component: 'transformation'
            method: 'create-sandbox'
            mode: 'button'
            label: "Load data"
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
        div {},
          if @state.pendingActions.get 'refresh'
            button {className: "btn btn-link", disabled: true},
              Loader()
              " Refresh privileges"
          else
            button {className: "btn btn-link", title: 'Refresh privileges', onClick: @_refreshCredentials},
              span {className: 'fa fa-fw fa-refresh'}
              " Refresh privileges"
        div {},
          DeleteButton
            tooltip: 'Delete Redshift Sandbox'
            isPending: @state.pendingActions.get 'drop'
            label: 'Drop credentials'
            fixedWidth: true
            confirm:
              title: 'Delete Redshift Sandbox'
              text: 'Do you really want to delete Redshift sandbox?'
              onConfirm: @_dropCredentials
    else
      if @state.pendingActions.get "create"
        span {},
          Loader()
          ' Creating credentials'
      else
        button {className: 'btn btn-link', onClick: @_createCredentials},
          i className: 'fa fa-fw fa-plus'
          ' Create credentials'

  render: ->
    div {className: 'row'},
      h4 {}, 'Redshift'
      div {className: 'col-md-9'},
        @_renderCredentials()
      div {className: 'col-md-3'},
        @_renderControlButtons()


  _createCredentials: ->
    CredentialsActionCreators.createRedshiftSandboxCredentials()

  _dropCredentials: ->
    CredentialsActionCreators.dropRedshiftSandboxCredentials()

  _refreshCredentials: ->
    CredentialsActionCreators.refreshRedshiftSandboxCredentials()


module.exports = RedshiftSandbox
