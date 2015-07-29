React = require 'react'
{Map} = require 'immutable'
classnames = require 'classnames'
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
RoutesStore = require '../../../../../stores/RoutesStore'

SearchRow = require '../../../../../react/common/SearchRow'
InstalledComponentsStore = require '../../../../components/stores/InstalledComponentsStore'
InstalledComponentsActions = require '../../../../components/InstalledComponentsActionCreators'

TablesByBucketsPanel = React.createFactory require('../../../../components/react/components/TablesByBucketsPanel')

ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
DeleteConfigurationButton = require '../../../../components/react/components/DeleteConfigurationButton'
ComponentMetadata = require '../../../../components/react/components/ComponentMetadata'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))


{i, strong, span, div, p, ul, li} = React.DOM

componentId = 'wr-google-drive'

module.exports = React.createClass
  displayName: 'WrGdriveIndex'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    configId = RoutesStore.getCurrentRouteParam('config')
    localState = InstalledComponentsStore.getLocalState(componentId, configId)


    #state
    configId: configId
    localState: localState
  render: ->
    console.log 'render'
    div {className: 'container-fluid'},
      @_renderMainContent()
      @_renderSideBar()

  _renderMainContent: ->
    div {className: 'col-md-9 kbc-main-content'},
      div className: 'row',
        ComponentDescription
          componentId: componentId
          configId: @state.configId


      if @_isAuthorized()
        React.createElement SearchRow,
          className: 'row kbc-search-row'
          onChange: @_handleSearchQueryChange
          query: @state.localState.get('searchQuery') or ''
      if @_isAuthorized()
        TablesByBucketsPanel
          renderTableRowFn: @_renderTableRow
          renderHeaderRowFn: @_renderHeaderRow
          filterFn: @_filterBuckets
          searchQuery: @state.localState.get('searchQuery')
          isTableExportedFn: -> false #@_isTableExported
          onToggleBucketFn: @_handleToggleBucket
          isBucketToggledFn: @_isBucketToggled
      else
        div className: 'row component-empty-state text-center',
          div null,
            p null, 'No Google Drive Account Authorized.'


  _renderSideBar: ->
    div {className: 'col-md-3 kbc-main-sidebar'},
      div className: 'kbc-buttons kbc-text-light',
        span null,
          'Authorized for '
        strong null,
          @_getAuthorizedForCaption()
        React.createElement ComponentMetadata,
          componentId: componentId
          configId: @state.configId

      ul className: 'nav nav-stacked',
        if @_isAuthorized()
          li null,
            span
              to: 'wr-google-drive-authorize'
              params:
                config: @state.configId
            ,
              i className: 'fa fa-fw fa-user'
              'Authorize TODO'
        li className: classnames(disabled: !!@_disabledToRun()),
          RunButtonModal
            disabled: !!@_disabledToRun()
            disabledReason: @_disabledToRun()
            title: "Upload tables"
            tooltip: "Upload all selected tables"
            mode: 'link'
            icon: 'fa fa-upload fa-fw'
            component: componentId
            runParams: =>
              writer: @state.configId
          ,
           "You are about to run upload of all seleted tables"
        li null,
          React.createElement DeleteConfigurationButton,
            componentId: componentId
            configId: @state.configId

  _renderHeaderRow: ->
    div className: 'tr',
      span className: 'th',
        strong null, 'Table name'
      span className: 'th',
        ''
      span className: 'th',
        strong null, 'Title'
      span className: 'th',
        strong null, 'Operation'
      span className: 'th',
        strong null, 'Type'
      span className: 'th',
        strong null, 'Preview'
      span className: 'th',
        strong null, 'Folder'

  _renderTableRow: (table) ->
    div className: 'tr',
      span className: 'td',
        table.get 'name'
      span className: 'td',
        i className: 'fa fa-fw fa-long-arrow-right'
      span className: 'td',
        'xxx'
      span className: 'td',
        'xxx'
      span className: 'td',
        'xxx'
      span className: 'td',
        'xxx'
      span className: 'td',
        'xxx'

  _isAuthorized: ->
    return true

  _disabledToRun: ->
    "TODO!!"

  _handleSearchQueryChange: (newQuery) ->
    @_updateLocalState(['searchQuery'], newQuery)


  _filterBuckets: (buckets) ->
    buckets = buckets.filter (bucket) ->
      bucket.get('stage') == 'out'
    return buckets

  _handleToggleBucket: (bucketId) ->
    newValue = !@_isBucketToggled(bucketId)
    bucketToggles = @state.localState.get 'bucketToggles', Map()
    newToggles = bucketToggles.set(bucketId, newValue)
    @_updateLocalState(['bucketToggles'], newToggles)

  _isBucketToggled: (bucketId) ->
    bucketToggles = @state.localState.get 'bucketToggles', Map()
    !!bucketToggles.get(bucketId)

  _getAuthorizedForCaption: ->
    'TODO!!'
  _updateLocalState: (path, data) ->
    newLocalState = @state.localState.setIn(path, data)
    InstalledComponentsActions.updateLocalState(componentId, @state.configId, newLocalState)
