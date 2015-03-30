React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
QueryEditor = React.createFactory(require('./QueryEditor'))

module.exports = React.createClass
  displayName: 'QueryEditorContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    transformation: React.PropTypes.object.isRequired
    value: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  render: ->
    component = @
    React.DOM.span {},
      if @props.transformation.get("backend") == "mysql" || @props.transformation.get("backend") == "redshift"
        React.DOM.p {className: "well"},
          "Keboola Connection does not support functions or stored procedures."
      QueryEditor
        mode: @_codeMirrorMode()
        value: @props.transformation.get("queries", "")
        disabled: @props.disabled
        onChange: @props.onChange

  _codeMirrorMode: ->
    mode = 'text/text'
    if @props.transformation.get('backend') == 'mysql'
      mode = 'text/x-mysql'
    else if @props.transformation.get('backend') == 'redshift'
      mode = 'text/x-sql'
    else if @props.transformation.get('backend') == 'docker' && @props.transformation.get('type') == 'r'
      mode = 'text/x-rsrc'
    return mode
