React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
RoutesStore = require '../../../../../stores/RoutesStore'

{div, span, input, strong, form, button, h4, i, button, small} = React.DOM

TransformationDetail = React.createClass
  displayName: 'TransformationDetail'
  mixins: [createStoreMixin(TransformationsStore, TransformationBucketsStore)]

  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformationId = RoutesStore.getCurrentRouteParam 'transformationId'
    transformation: TransformationsStore.getTransformations(transformationId)
    bucket: TransformationBucketsStore.get(bucketId)

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'row kbc-header' #,
        #TransformationDescription
        #  componentId: 'transformation'
        #  configId: @state.bucket.get 'id'

module.exports = TransformationDetail
