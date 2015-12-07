React = require 'react'

{button, span, div} = React.DOM

Link = React.createFactory(require('react-router').Link)
RoutesStore = require('../../../../stores/RoutesStore.coffee')
ComponentsStore = require('../../stores/ComponentsStore.coffee')
createStoreMixin = require('../../../../react/mixins/createStoreMixin.coffee')

Modal = React.createFactory(require('react-bootstrap').Modal)
ModalHeader = React.createFactory(require('react-bootstrap/lib/ModalHeader'))
ModalBody = React.createFactory(require('react-bootstrap/lib/ModalBody'))
ModalFooter = React.createFactory(require('react-bootstrap/lib/ModalFooter'))
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
NewComponentModal = React.createFactory(require('../pages/new-component-form/NewComponentModal'))

module.exports = React.createClass
  displayName: 'AddComponentConfigurationButton'

  propTypes:
    component: React.PropTypes.object.isRequired

  getInitialState: ->
    showModal: false

  close: ->
    @setState showModal: false

  open: ->
    @setState showModal: true


  render: ->
    div null,
      button
        className: 'btn btn-success'
        onClick: @open
      ,
        span className: 'kbc-icon-plus'
        'Add Configuration'
      Modal
        show: @state.showModal
        onHide: @close
      ,
        NewComponentModal
          component: @props.component
          onClose: @close
