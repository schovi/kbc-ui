React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ComponentsStore  = require('../../../../components/stores/ComponentsStore')

{div, span, input, strong, form, button, h4, i, button, small, ul, li, a} = React.DOM
Sandbox = React.createClass
  displayName: 'Sandbox'
  #mixins: [createStoreMixin(TransformationBucketsStore)]

  #getStateFromStores: ->
  #  buckets: TransformationBucketsStore.getAll()
  #  pendingActions: TransformationBucketsStore.getPendingActions()

  render: ->
    span {}, "sandbox"
    

module.exports = Sandbox
