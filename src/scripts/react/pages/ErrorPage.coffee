React = require 'react'

createStoreMixin = require '../mixins/createStoreMixin'
RoutesStore = require '../../stores/RoutesStore'
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
        div null,
          p null, @state.error?.getText()
          if @state.error?.getExceptionId()
            p null, 'Exception id: ' + @state.error?.getExceptionId()

module.exports = ErrorPage
