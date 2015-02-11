React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin.coffee'
ExGanalStore = require '../../../exGanalStore.coffee'
RoutesStore = require '../../../../../stores/RoutesStore.coffee'

#RunExtraction = React.createFactory(require '../../components/RunExtraction.coffee')

ComponentDescription = require '../../../../components/react/components/ComponentDescription.coffee'
ComponentDescription = React.createFactory(ComponentDescription)
Link = React.createFactory(require('react-router').Link)

#ItemsTable = React.createFactory(require './ItemsTable.coffee')

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalIndex'
  #mixins: [createStoreMixin(ExGanalStore)]

  getStateFromStores: ->
    null

  render: ->
    div {}, 'blabla'
