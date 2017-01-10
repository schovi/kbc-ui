React = require('react')
Immutable = require('immutable')

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
ComponentsStore = require('../../../components/stores/ComponentsStore')
RedshiftSandboxCredentialsStore = require('../../../provisioning/stores/RedshiftSandboxCredentialsStore')
CredentialsActionCreators = require('../../../provisioning/ActionCreators')
RedshiftCredentials = React.createFactory(require('../../../provisioning/react/components/RedshiftCredentials'))
ConfigureSandbox = React.createFactory(require '../components/ConfigureSandbox')
LoadDataIntoWorkspaceButton =
  React.createFactory(require '../../../components/react/components/LoadDataIntoWorkspaceButton')
DeleteButton = React.createFactory(require '../../../../react/common/DeleteButton')
Loader = React.createFactory(require('kbc-react-components').Loader)
StorageBucketsStore = require '../../../components/stores/StorageBucketsStore'
StorageTablesStore = require '../../../components/stores/StorageTablesStore'
contactSupport = require('../../../../utils/contactSupport').default
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
RedshiftSSLInfoModal = React.createFactory(require './RedshiftSSLInfoModal')
ApplicationStore = require '../../../../stores/ApplicationStore'
sandboxConfigurationTool = require '../../utils/sandboxConfiguration'

{div, span, input, strong, form, button, h3, h4, i, button, small, ul, li, a} = React.DOM
RedshiftSandbox = React.createClass

  mixins: [createStoreMixin(
    RedshiftSandboxCredentialsStore,
    StorageBucketsStore,
    StorageTablesStore
  )]

  displayName: 'RedshiftSandbox'

  getStateFromStores: ->
    credentials: RedshiftSandboxCredentialsStore.getCredentials()
    pendingActions: RedshiftSandboxCredentialsStore.getPendingActions()
    isLoading: RedshiftSandboxCredentialsStore.getIsLoading()
    isLoaded: RedshiftSandboxCredentialsStore.getIsLoaded()
    tables: StorageTablesStore.getAll()
    buckets: StorageBucketsStore.getAll()

  getInitialState: ->
    showSSLInfoModal: false

  _openSupportModal: (e) ->
    contactSupport(type: 'project')
    e.preventDefault()
    e.stopPropagation()

  _renderCredentials: ->
    span {},
      RedshiftCredentials {credentials: @state.credentials, isCreating: @state.pendingActions.get("create")}

  _renderControlButtons: ->
    state = @state
    if @state.credentials.get "id"
      sandboxConfiguration = {}
      div {},
        div {},
          LoadDataIntoWorkspaceButton(
            title: "Load tables into Redshift sandbox"
            mode: 'button'
            label: "Load data"
            disabled: @state.pendingActions.get 'drop'
            workspaceId: @state.credentials.get 'workspaceId'
            runParams: ->
              sandboxConfiguration
          ,
            ConfigureSandbox
              backend: 'redshift'
              tables: @state.tables
              buckets: @state.buckets
              onChange: (params) ->
                sandboxConfiguration = sandboxConfigurationTool(params, state.tables.toList().toJS())
          )
        div {},
          OverlayTrigger
            overlay: Tooltip null, "Information about secure connection"
            key: 'ssl'
            placement: 'top'
          ,
            button
              className: "btn btn-link"
              onClick: @_showSSLInfoModal
              disabled: @state.pendingActions.get 'drop'
            ,
              span {className: 'fa fa-fw fa-lock '}
              " SSL"
          RedshiftSSLInfoModal {show: @state.showSSLInfoModal, onHide: @_hideSSLInfoModal}
        div {},
          DeleteButton
            tooltip: 'Delete Redshift Sandbox'
            isPending: @state.pendingActions.get 'drop'
            label: 'Drop sandbox'
            fixedWidth: true
            confirm:
              title: 'Delete Redshift Sandbox'
              text: 'Do you really want to delete Redshift sandbox?'
              onConfirm: @_dropCredentials
    else
      if !@state.pendingActions.get("create")
        button {className: 'btn btn-link', onClick: @_createCredentials},
          i className: 'fa fa-fw fa-plus'
          ' Create sandbox'

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

  _showSSLInfoModal: ->
    @setState({showSSLInfoModal: true})

  _hideSSLInfoModal: ->
    @setState({showSSLInfoModal: false})


module.exports = RedshiftSandbox
