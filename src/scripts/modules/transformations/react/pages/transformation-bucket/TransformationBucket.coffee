React = require('react')
Link = React.createFactory(require('react-router').Link)
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
InstalledComponentsStore  = require('../../../../components/stores/InstalledComponentsStore.coffee')

{div, span, input, strong, form, button, h4, i, button, small} = React.DOM
TransformationBucket = React.createClass
  displayName: 'TransformationsIndex'
  mixins: [createStoreMixin(InstalledComponentsStore)]

  getStateFromStores: ->
    buckets: InstalledComponentsStore.getComponent('transformation').get('configurations')

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      "test"  

module.exports = TransformationBucket
