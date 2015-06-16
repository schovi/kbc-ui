React = require 'react'
DocumentTitle = React.createFactory(require 'react-document-title')

createStoreMixin = require '../mixins/createStoreMixin'
RoutesStore = require '../../stores/RoutesStore'
ApplicationStore = require '../../stores/ApplicationStore'

module.exports = React.createClass
  displayName: 'PageTitle'
  mixins: [createStoreMixin(RoutesStore)]

  getStateFromStores: ->
    pageTitle: ApplicationStore.getCurrentProject().get('name') + ' - ' + @breadcrumbs()

  breadcrumbs: ->
    RoutesStore
    .getBreadcrumbs()
    .map (page) ->
      page.get 'title'
    .join ' / '

  render: ->
    DocumentTitle title: @state.pageTitle
