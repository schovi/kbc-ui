React = require 'react'
_ = require 'underscore'
exGanalStore = require('../../../exGanalStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalActionCreators  = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'
QueryEditor = React.createFactory(require '../../components/QueryEditor')
Input = React.createFactory(require('react-bootstrap').Input)
Label = React.createFactory(require('react-bootstrap').Label)

{div, form} = React.DOM
module.exports = React.createClass
  displayName: 'ExGanalQueryDetail'
  mixins: [createStoreMixin(exGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    name = RoutesStore.getRouterState().getIn ['params', 'name']
    config = exGanalStore.getConfig(configId)
    configId: configId
    query: exGanalStore.getQuery(configId, name)
    editingQuery: exGanalStore.getEditingQuery(configId, name)
    name: name
    isEditing: exGanalStore.isEditingQuery(configId, name)
    profiles: config.get 'items'
    validation: exGanalStore.getQueryValidation(configId, name)

  render: ->
    console.log 'rendering query', @state.query.toJS()
    if @state.isEditing
      QueryEditor
        configId: @state.configId
        onChange: @_onQueryChange
        query: @state.editingQuery
        profiles: @state.profiles
        validation: @state.validation
    else
      div {className: 'container-fluid kbc-main-content'},
        form className: 'form-horizontal',
          div className: 'row',
            @_createStaticInput('Name', 'name')
            @_createStaticInput('Metrics', 'metrics', true)
            @_createStaticInput('Dimensions', 'dimensions', true)
            @_createStaticInput('Filters', 'filters')
            @_createStaticInput('Profile', 'profile')

  _createStaticInput: (caption, propName, isArray = false) ->
    pvalue = @state.query.get(propName)
    if isArray
      pvalue = pvalue.toJS().join(',')
    if propName == 'filters'
      pvalue = if pvalue then pvalue.get(0) else 'n/a'
    if propName == 'name'
      pvalue = @state.name
    if propName == 'profile'
      pvalue = if pvalue then @_assmbleProfileName(pvalue) else '--all--'
    Input
      label: caption
      type: 'static'
      value: pvalue
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'

  _assmbleProfileName: (profileId) ->
    profile = @state.profiles.find( (p) ->
      p.get('googleId') == profileId
    )
    if profile
      accountName = profile.get('accountName')
      propertyName = profile.get('webPropertyName')
      pname = profile.get('name')
      return "#{accountName}/ #{propertyName}/ #{pname}"
    else
      return "Unknown Profile(#{profileId})"



  _onQueryChange: (newQuery) ->
    console.log "query changed", newQuery.toJS()
    ExGanalActionCreators.changeQuery(@state.configId, @state.name, newQuery)
