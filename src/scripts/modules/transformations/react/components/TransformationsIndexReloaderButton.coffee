React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'

TransformationActionCreators = require '../../ActionCreators'
TransformationBucketsStore = require '../../stores/TransformationBucketsStore'
RefreshIcon = React.createFactory(require('kbc-react-components').RefreshIcon)
{Loader} = require 'kbc-react-components'

TransformationsIndexReloaderButton = React.createClass
  displayName: 'TransformationsIndexReloaderButton'
  mixins: [createStoreMixin(TransformationBucketsStore)]

  propTypes:
    allowRefresh: React.PropTypes.bool

  getDefaultProps: ->
    allowRefresh: false

  getStateFromStores: ->
    isLoading: TransformationBucketsStore.getIsLoading()

  _handleRefreshClick: (e) ->
    TransformationActionCreators.loadTransformationBucketsForce()

  render: ->
    if @props.allowRefresh
      RefreshIcon isLoading: @state.isLoading, onClick: @_handleRefreshClick
    else
      if @state.isLoading
        React.createElement Loader
      else
        return null


module.exports = TransformationsIndexReloaderButton
