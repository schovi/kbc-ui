React = require 'react'

TreeNode = React.createFactory(require './TreeNode.coffee')

Tree = React.createClass
  displayName: 'Tree'
  propTypes:
    data: React.PropTypes.object.isRequired

  render: ->
    React.DOM.div className: 'kb-tree', onClick: @props.onClick,
      TreeNode data: @props.data


module.exports = Tree