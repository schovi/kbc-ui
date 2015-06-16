React = require('react')
Immutable = require('immutable')

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
RedshiftSandboxCredentialsStore = require('../../../provisioning/stores/RedshiftSandboxCredentialsStore')
RedshiftCredentials = React.createFactory(require('../../../provisioning/react/components/RedshiftCredentials'))
CredentialsActionCreators = require('../../../provisioning/ActionCreators')

{div, span, input, strong, form, button, h3, h4, i, button, small, ul, li, a} = React.DOM
RedshiftCredentialsContainer = React.createClass

  mixins: [createStoreMixin(RedshiftSandboxCredentialsStore)]

  displayName: 'RedshiftCredentialsContainer'

  componentDidMount: ->
    if (!@state.credentials.get("id") && @props.isAutoLoad)
      CredentialsActionCreators.createRedshiftSandboxCredentials()

  propTypes:
    isAutoLoad: React.PropTypes.bool.isRequired

  getStateFromStores: ->
    credentials: RedshiftSandboxCredentialsStore.getCredentials()
    pendingActions: RedshiftSandboxCredentialsStore.getPendingActions()
    isLoading: RedshiftSandboxCredentialsStore.getIsLoading()
    isLoaded: RedshiftSandboxCredentialsStore.getIsLoaded()

  render: ->
    RedshiftCredentials {credentials: @state.credentials, isCreating: @state.pendingActions.get("create")}

module.exports = RedshiftCredentialsContainer
