React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')
CredentialsStore = require('../../../../provisioning/stores/CredentialsStore')
CredentialsActionCreators = require('../../../../provisioning/ActionCreators')
MySqlCredentials = require('../../../../provisioning/react/components/MySqlCredentials')
RedshiftCredentials = require('../../../../provisioning/react/components/RedshiftCredentials')

{div, span, input, strong, form, button, h3, h4, i, button, small, ul, li, a} = React.DOM
Sandbox = React.createClass
  displayName: 'Sandbox'
  mixins: [createStoreMixin(CredentialsStore)]

  getStateFromStores: ->
    mySqlCredentials: CredentialsStore.getByBackendAndType("mysql", "sandbox")
    redshiftCredentials: CredentialsStore.getByBackendAndType("redshift", "sandbox")

  mySqlCredentials: ->
    if @state.mySqlCredentials
      return span {},
        MySqlCredentials {credentials: @state.mySqlCredentials, linkToSandbox: true}
        button {className: "btn btn-default", onClick: @_dropMySqlCredentials}, 'Drop'
    else
      return button {className: 'btn btn-success', onClick: @_createMySqlCredentials},
        'Create MySql Credentials'


  redshiftCredentials: ->
    if @state.redshiftCredentials
      return span {},
        RedshiftCredentials {credentials: @state.redshiftCredentials}
        button {className: "btn btn-default", onClick: @_dropRedshiftCredentials}, 'Drop'
        button {className: "btn btn-default", onClick: @_refreshRedshiftCredentials}, 'Refresh'
    else
      return button {className: 'btn btn-success', onClick: @_createRedshiftCredentials},
        'Create Redshift Credentials'
 
  render: ->
    div {className: 'container-fluid'},
      div {className: 'col-md-12 kbc-main-content'},
        div {className: 'table kbc-table-border-vertical kbc-detail-table'},
          div {className: 'tr'},
            div {className: 'td'},
              h4 {}, 'MySQL'
            div {className: 'td'},
              @mySqlCredentials()
        div {className: 'table kbc-table-border-vertical kbc-detail-table'},
          div {className: 'tr'},
            div {className: 'td'},
              h4 {}, 'Redshift'
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
