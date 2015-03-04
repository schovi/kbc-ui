React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Select = require('react-select')
_ = require('underscore')
InstalledComponentsActionCreators = require '../../../components/InstalledComponentsActionCreators'
StorageBucketsStore = require '../../../components/stores/StorageBucketsStore'
StorageTablesStore = require '../../../components/stores/StorageTablesStore'

{div, p, strong, form, input, label, textarea} = React.DOM

ConfigureSandbox = React.createClass
  displayName: 'Configure'

  propTypes:
    backend: React.PropTypes.string.isRequired
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
      () ->
        @props.onChange(@state)

  _setExclude: (string, array) ->
    values = _.map(array, (item) ->
      item.value
    )
    @setState
      exclude: values
    ,
      () ->
        @props.onChange(@state)

  _setRows: (e) ->
    rows = e.target.value.trim()
    @setState
      rows: rows
    ,
      () ->
        @props.onChange(@state)

  _setPreserve: (e) ->
    preserve = e.target.checked
    @setState
      preserve: preserve
    ,
      () ->
        @props.onChange(@state)

  _bucketsAndTables: ->
    buckets = StorageBucketsStore.getAll()
    tables = StorageTablesStore.getAll()
    nodes = _.sortBy(_.union(
      _.map(_.filter(buckets, (bucket) ->
        bucket.id.substr(0, 3) == 'in.' || bucket.id.substr(0, 4) == 'out.'
      ), (bucket) ->
        {
        label: bucket.id
        value: bucket.id
        }
      )
    ,
      _.map(_.filter(tables, (table) ->
        table.id.substr(0, 3) == 'in.' || table.id.substr(0, 4) == 'out.'
      ), (table) ->
        {
          label: table.id
          value: table.id
        }
      )
    )
    , (option) ->
      option.label
    )
    return nodes

module.exports = ConfigureSandbox
