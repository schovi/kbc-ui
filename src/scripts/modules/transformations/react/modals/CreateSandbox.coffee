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

CreateSandbox = React.createClass
  displayName: 'CreateSandbox'

  propTypes:
    backend: React.PropTypes.string.isRequired

  getInitialState: ->
    preserve: false
    backend: @props.backend
    include: []
    exclude: []
    rows: 0

  render: ->
    Modal title: "Create Sandbox", onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
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
      div className: 'modal-footer',
        ButtonToolbar null,
          Button onClick: @props.onRequestHide,
            'Cancel'
          Button bsStyle: 'primary', onClick: @_handleCreate,
            'Create'

  _setInclude: (string, array) ->
    values = _.map(array, (item) ->
      item.value
    )
    @setState
      include: values

  _setExclude: (string, array) ->
    values = _.map(array, (item) ->
      item.value
    )
    @setState
      exclude: values

  _setRows: (e) ->
    rows = e.target.value.trim()
    @setState
      rows: rows

  _setPreserve: (e) ->
    preserve = e.target.checked
    @setState
      preserve: preserve

  _handleCreate: ->
    InstalledComponentsActionCreators.runComponent(
      component: 'transformation'
      method: 'create-sandbox'
      params:
        backend: @state.backend
        preserve: @state.preserve
        rows: @state.rows
        include: @state.include
        exclude: @state.exclude
    ).then @props.onRequestHide

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


module.exports = CreateSandbox
