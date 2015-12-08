React = require 'react'
Markdown = React.createFactory(require 'react-markdown')
{div} = React.DOM

module.exports = React.createClass
  displayName: 'ComponentDescription'
  propTypes:
    component: React.PropTypes.object.isRequired

  render: ->
    if (@props.component.get('longDescription'))
      return Markdown
        source: @props.component.get('longDescription')
        escapeHtml: true
    else
      return null

