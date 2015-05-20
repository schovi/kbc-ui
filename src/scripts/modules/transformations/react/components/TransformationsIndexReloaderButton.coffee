React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'

TransformationActionCreators = require '../../ActionCreators'
TransformationBucketsStore = require '../../stores/TransformationBucketsStore'
RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)

TransformationsIndexReloaderButton = React.createClass
  displayName: 'TransformationsIndexReloaderButton'
  mixins: [createStoreMixin(TransformationBucketsStore)]

  getStateFromStores: ->
    isLoading: TransformationBucketsStore.getIsLoading()

  _handleRefreshClick: (e) ->
    TransformationActionCreators.loadTransformationBucketsForce()

  render: ->
    RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick


module.exports = TransformationsIndexReloaderButton