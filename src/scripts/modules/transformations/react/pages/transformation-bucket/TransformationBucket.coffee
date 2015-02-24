React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationBucketsStore')

{div, span, input, strong, form, button, h4, i, button, small} = React.DOM
TransformationBucket = React.createClass
  displayName: 'TransformationsIndex'
  mixins: [createStoreMixin(TransformationsStore)]

  getStateFromStores: ->
    transformations: TransformationsStore.getAll()

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      @state.transformations.map((transformation) ->
        div {}, transformation.get("name")
      , @).toArray()

module.exports = TransformationBucket
