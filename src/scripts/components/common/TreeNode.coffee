React = require 'react'
Immutable = require 'immutable'

{ul, li, span, strong} = React.DOM

TreeNode = React.createClass
  displayName: 'TreeNode'
  propTypes:
    data: React.PropTypes.object.isRequired

  render: ->
    ul null, @props.data.map((value, key) ->
      li null,
        if Immutable.Iterable.isIterable(value)
          span null,
            strong null, key
            React.createElement(TreeNode, data: value)
        else
          span null,
            strong null, key
            ': '
            value
    ).toJS()


module.exports = TreeNode