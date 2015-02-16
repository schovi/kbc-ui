React = require 'react'

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalStore = require '../../../exGanalStore'
RoutesStore = require '../../../../../stores/RoutesStore'

#RunExtraction = React.createFactory(require '../../components/RunExtraction')

ComponentDescription = require '../../../../components/react/components/ComponentDescription'
ComponentDescription = React.createFactory(ComponentDescription)
Link = React.createFactory(require('react-router').Link)

#ItemsTable = React.createFactory(require './ItemsTable')

{strong, br, ul, li, div, span, i} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalIndex'
  #mixins: [createStoreMixin(ExGanalStore)]

  getStateFromStores: ->
    null

  render: ->
    div {}, 'blabla'
