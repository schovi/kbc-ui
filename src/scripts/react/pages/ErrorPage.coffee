React = require 'react'

createStoreMixin = require '../mixins/createStoreMixin.coffee'
RoutesStore = require '../../stores/RoutesStore.coffee'
Alert = React.createFactory(require('react-bootstrap').Alert)

{div, p} = React.DOM

ErrorPage = React.createClass
  displayName: 'ErrorPage'
  mixins: [createStoreMixin(RoutesStore)]

  getStateFromStores: ->
    error: RoutesStore.getError()

  render: ->
    div className: 'container-fluid kbc-main-content',
      Alert bsStyle: 'danger',
        p null, @state.error?.getText()

module.exports = ErrorPage