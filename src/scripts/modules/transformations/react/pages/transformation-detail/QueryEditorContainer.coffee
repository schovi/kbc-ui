React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
QueryEditor = React.createFactory(require('./QueryEditor'))

module.exports = React.createClass
  displayName: 'QueryEditorContainer'
  mixins: [ImmutableRenderMixin]

  propTypes:
    transformation: React.PropTypes.object.isRequired
    value: React.PropTypes.string
    onChange: React.PropTypes.func.isRequired
    disabled: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    value: ''

  render: ->
    component = @
    React.DOM.span {},
      if @props.transformation.get("backend") == "mysql"
        React.DOM.p {className: "well"},
          "Keboola Connection does not officially support MySQL functions or stored procedures. Use at your own risk."
      if @props.transformation.get("backend") == "redshift"
        React.DOM.p {className: "well"},
          "Redshift does not support functions or stored procedures."
      if @props.transformation.get("backend") == "docker" && @props.transformation.get("type") == "r"
        React.DOM.p {className: "well"},
          "Read on "
          React.DOM.a
            href: "https://sites.google.com/a/keboola.com/wiki/home/keboola-connection" +
              "/devel-space/transformations/backends/docker/r-limitations-and-best-practices"
          ,
            "R limitations and best practices"
          "."
      if @props.transformation.get("backend") == "docker" && @props.transformation.get("type") == "r"
        React.DOM.p {className: "well"},
          "All source tables are stored in "
          React.DOM.code {}, "/data/in/tables"
          "(relative path "
          React.DOM.code {}, "in/tables"
          "), save all tables for output mapping to "
          React.DOM.code {}, "/data/out/tables"
          " (relative path "
          React.DOM.code {}, "out/tables"
          ")."

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
