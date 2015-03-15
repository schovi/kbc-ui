React = require 'react'

ModalTrigger = React.createFactory(require('react-bootstrap').ModalTrigger)
SqlDepModal = React.createFactory(require('./SqlDepModal'))

SqlDepModalTrigger = React.createClass
  displayName: 'SqlDepModal'

  propTypes:
    backend: React.PropTypes.string.isRequired
    transformationId: React.PropTypes.string.isRequired
    bucketId: React.PropTypes.string.isRequired

  render: ->
    child = React.Children.only @props.children
    ModalTrigger
      modal: SqlDepModal(@props)
    ,
      React.addons.cloneWithProps child,
        onClick: (e) ->
          e.preventDefault()
          e.stopPropagation()

module.exports = SqlDepModalTrigger
