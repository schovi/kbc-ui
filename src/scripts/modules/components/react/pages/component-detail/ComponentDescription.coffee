React = require 'react'
Markdown = React.createFactory(require 'react-markdown')

module.exports = React.createClass
  displayName: 'appUsageInfo'
  propTypes:
    component: React.PropTypes.object.isRequired

  render: ->
    Markdown
      source: @props.component.get('longDescription')
      escapeHtml: true

