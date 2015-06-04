React = require 'react'
{span, div, a, p, h2, label, input, form} = React.DOM
Input = React.createFactory(require('react-bootstrap').Input)
createStoreMixin = require '../../../../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../../../../../components/stores/InstalledComponentsStore'
RoutesStore = require '../../../../../../../stores/RoutesStore'
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)

module.exports = React.createClass

  displayName: 'GeneeaAppDetail'

  mixins: [createStoreMixin(InstalledComponentsStore)]
  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    configData = InstalledComponentsStore.getConfigData("geneea-topic-detection", configId)
    #console.log "geneea get state from store", configData.toJS()
    inputTables = configData?.getIn ['configuration', 'storage', 'input', 'tables']
    intable = inputTables?.get(0)?.get 'source'

    outTables = configData?.getIn ['configuration', 'storage', 'output', 'tables']
    outTable = outTables?.get(0)?.get 'source'
    parameters = configData?.getIn ['configuration','parameters']

    data_column: parameters?.get 'data_column'
    primary_key_column: parameters?.get 'primary_key_column'
    intable: intable
    outTable: outTable





  render: ->

    div {className: 'container-fluid kbc-main-content'},
         form className: 'form-horizontal',
           div className: 'row',
             @_createStaticInput('Input Table', @state.intable)
             @_createStaticInput('Data Column', @state.data_column)
             @_createStaticInput('Primary Key', @state.primary_key_column)
             @_createStaticInput('Output Table', @state.outTable)


  _createStaticInput: (caption, value) ->
    pvalue =
    StaticText
      label: caption
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
    , value or 'N/A'
