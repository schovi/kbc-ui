React = require 'react'
DocumentTitle = React.createFactory(require 'react-document-title')

createStoreMixin = require '../mixins/createStoreMixin.coffee'
RoutesStore = require '../../stores/RoutesStore.coffee'
ApplicationStore = require '../../stores/ApplicationStore.coffee'

module.exports = React.createClass
  displayName: 'PageTitle'
  mixins: [createStoreMixin(RoutesStore)]

  getStateFromStores: ->
    pageTitle: ApplicationStore.getCurrentProject().get('name') + ' - ' + RoutesStore.getCurrentRouteTitle()

  render: ->
    DocumentTitle title: @state.pageTitle
