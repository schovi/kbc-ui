React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Select = React.createFactory(require('react-select'))
_ = require('underscore')
InstalledComponentsActionCreators = require '../../../components/InstalledComponentsActionCreators'

{div, p, strong, form, input, label, textarea} = React.DOM

ConfigureSandbox = React.createClass
  displayName: 'Configure'

  propTypes:
    backend: React.PropTypes.string.isRequired
    tables: React.PropTypes.object.isRequired
    buckets: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired

  getInitialState: ->
    preserve: false
    backend: @props.backend
    include: []
    exclude: []
    rows: 0

  render: ->
    form className: 'form-horizontal',
      div className: 'form-group',
        label className: 'col-sm-4 control-label', 'Backend'
        div className: 'col-sm-6',
          p className: 'form-control-static', @state.backend
      div className: 'form-group',
        label className: 'col-sm-4 control-label', 'Include'
        div className: 'col-sm-6',
          Select
            name: 'include'
            value: @state.include
            multi: true
            options: @_bucketsAndTables()
            delimiter: ','
            onChange: @_setInclude
            placeholder: 'Select buckets and tables...'
      div className: 'form-group',
        label className: 'col-sm-4 control-label', 'Exclude'
        div className: 'col-sm-6',
          Select
            name: 'exclude'
            value: @state.exclude
            multi: true
            options: @_bucketsAndTables()
            delimiter: ','
            onChange: @_setExclude
            placeholder: 'Select buckets and tables...'
      div className: 'form-group',
        label className: 'col-sm-4 control-label', 'Rows'
        div className: 'col-sm-6',
          input
            type: 'number'
            placeholder: 'Number of rows'
            className: 'form-control'
            value: @state.rows
            onChange: @_setRows
            ref: 'exclude'
      div className: 'form-group',
        label className: 'col-sm-4 control-label'
        div className: 'col-sm-6',
          label className: 'control-label',
            input
              type: 'checkbox'
              onChange: @_setPreserve
              ref: 'preserve'
            'Preserve'

  _setInclude: (string, array) ->
    values = _.map(array, (item) ->
      item.value
    )
    @setState
      include: values
    ,
      ->
        @props.onChange(@state)

  _setExclude: (string, array) ->
    values = _.map(array, (item) ->
      item.value
    )
    @setState
      exclude: values
    ,
      ->
        @props.onChange(@state)

  _setRows: (e) ->
    rows = e.target.value.trim()
    @setState
      rows: rows
    ,
      ->
        @props.onChange(@state)

  _setPreserve: (e) ->
    preserve = e.target.checked
    @setState
      preserve: preserve
    ,
      ->
        @props.onChange(@state)

  _bucketsAndTables: ->
    nodes = _.sortBy(_.union(
      _.map(_.filter(@props.buckets.toArray(), (bucket) ->
        bucket.get('id').substr(0, 3) == 'in.' || bucket.get('id').substr(0, 4) == 'out.'
      ), (bucket) ->
        {
        label: bucket.get('id')
        value: bucket.get('id')
        }
      )
    ,
      _.map(_.filter(@props.tables.toArray(), (table) ->
        table.get('id').substr(0, 3) == 'in.' || table.get('id').substr(0, 4) == 'out.'
      ), (table) ->
        {
          label: table.get('id')
          value: table.get('id')
        }
      )
    )
    , (option) ->
      option.label
    )
    return nodes

module.exports = ConfigureSandbox
