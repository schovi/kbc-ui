React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ComponentsStore = require('../../../components/stores/ComponentsStore')
SnowflakeSandboxCredentialsStore = require('../../../provisioning/stores/SnowflakeSandboxCredentialsStore')
CredentialsActionCreators = require('../../../provisioning/ActionCreators')
SnowflakeCredentials = React.createFactory(require('../../../provisioning/react/components/SnowflakeCredentials'))
ConfigureSandbox = React.createFactory(require '../components/ConfigureSandbox')
RunComponentButton = React.createFactory(require '../../../components/react/components/RunComponentButton')
DeleteButton = React.createFactory(require '../../../../react/common/DeleteButton')
Loader = React.createFactory(require('kbc-react-components').Loader)
StorageBucketsStore = require '../../../components/stores/StorageBucketsStore'
StorageTablesStore = require '../../../components/stores/StorageTablesStore'
contactSupport = require('../../../../utils/contactSupport').default

{div, span, input, strong, form, button, h3, h4, i, button, small, ul, li, a} = React.DOM
SnowflakeSandbox = React.createClass

  mixins: [createStoreMixin(
    SnowflakeSandboxCredentialsStore,
    StorageBucketsStore,
    StorageTablesStore
  )]

  displayName: 'SnowflakeSandbox'

  getStateFromStores: ->
    credentials: SnowflakeSandboxCredentialsStore.getCredentials()
    pendingActions: SnowflakeSandboxCredentialsStore.getPendingActions()
    isLoading: SnowflakeSandboxCredentialsStore.getIsLoading()
    isLoaded: SnowflakeSandboxCredentialsStore.getIsLoaded()
    tables: StorageTablesStore.getAll()
    buckets: StorageBucketsStore.getAll()

  _openSupportModal: (e) ->
    contactSupport(type: 'project')
    e.preventDefault()
    e.stopPropagation()

  _renderCredentials: ->
    span {},
      SnowflakeCredentials {credentials: @state.credentials, isCreating: @state.pendingActions.get("create")}

  _renderControlButtons: ->
    if @state.credentials.get "id"
      sandboxConfiguration = {}
      div {},
        div {},
          RunComponentButton(
            title: "Load tables into Snowflake sandbox"
            component: 'transformation'
            method: 'create-sandbox'
            mode: 'button'
            label: "Load data"
            runParams: ->
              sandboxConfiguration
          ,
            ConfigureSandbox
              backend: 'snowflake'
              tables: @state.tables
              buckets: @state.buckets
              onChange: (params) ->
                sandboxConfiguration = params
          )

        div {},
          a {href: 'https://' + @state.credentials.get('hostname'), className: 'btn btn-link', target: '_blank'},
            span {className: 'fa fa-fw fa-database'}
            " Connect"

        div {},
          DeleteButton
            tooltip: 'Delete Snowflake Sandbox'
            isPending: @state.pendingActions.get 'drop'
            label: 'Drop credentials'
            fixedWidth: true
            confirm:
              title: 'Delete Snowflake Sandbox'
              text: 'Do you really want to delete Snowflake sandbox?'
              onConfirm: @_dropCredentials
    else
      if !@state.pendingActions.get("create")
        button {className: 'btn btn-link', onClick: @_createCredentials},
          i className: 'fa fa-fw fa-plus'
          ' Create credentials'

  render: ->
    div {className: 'row'},
      h4 {}, 'Snowflake'
      div {className: 'col-md-9'},
        @_renderCredentials()
      div {className: 'col-md-3'},
        @_renderControlButtons()

  _createCredentials: ->
    CredentialsActionCreators.createSnowflakeSandboxCredentials()

  _dropCredentials: ->
    CredentialsActionCreators.dropSnowflakeSandboxCredentials()

  _refreshCredentials: ->
    CredentialsActionCreators.refreshSnowflakeSandboxCredentials()

module.exports = SnowflakeSandbox
