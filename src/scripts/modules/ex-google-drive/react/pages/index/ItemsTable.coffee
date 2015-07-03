React = require('react')
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

Link = React.createFactory(require('react-router').Link)
DeleteSheetButton = React.createFactory(require '../../components/DeleteSheetButton')
Loader = React.createFactory(require('kbc-react-components').Loader)
RunExtractionButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
{Loader} = require 'kbc-react-components'

{i, span, div, a, strong} = React.DOM

module.exports = React.createClass
  displayName: 'ItemsTable'
  mixins: [ImmutableRenderMixin]
  propTypes:
    items: React.PropTypes.object
    deletingSheets: React.PropTypes.object
    savingSheets: React.PropTypes.object
    # configurationId: number

  render: ->
    childs = @props.items.map((row, rowkey) ->
      configurationId = @props.configurationId
      Link
        className: 'tr'
        to: 'ex-google-drive-sheet'
        key: rowkey
        params:
          config: @props.configurationId
          fileId: row.get 'fileId'
          sheetId: row.get 'sheetId'
        div className: 'td', row.get 'title'
        div className: 'td', row.get 'sheetTitle'
        div className: 'td',
          i className: 'kbc-icon-arrow-right'
        div className: 'td',
          if @_isSheetSaving(row)
            React.createElement Loader
          else
            @_rawConfig(row)?.db?.table or "n/a"
        div className: 'td text-right kbc-no-wrap',
          if @_isSheetDeleting(row.get('fileId'), row.get('sheetId'))
            Loader()
          else
            DeleteSheetButton
              sheet: row
              configurationId: @props.configurationId
          RunExtractionButton
            title: 'Run Extraction'
            component: 'ex-google-drive'
            runParams: ->
              sheetId: row.get 'sheetId'
              googleId: row.get 'googleId'
              config: configurationId
          ,
            "You are about to run extraction of #{row.get('title')}-#{row.get('sheetTitle')}"

    , @).toArray()

    div className: 'table table-striped table-hover',
      div className: 'thead', key: 'table-header',
        div className: 'tr',
          span className: 'th',
            strong null, 'Document Title'
          span className: 'th',
            strong null, 'Sheet Title'
          span className: 'th',""# -> arrow
          span className: 'th',
            strong null, 'Output Table'
          span className: 'th' #actions buttons
      div className: 'tbody',
        childs

  _isSheetDeleting: (fileId, sheetId) ->
    @props.deletingSheets and @props.deletingSheets.hasIn [fileId,sheetId]
  _rawConfig: (row) ->
    JSON.parse(row.get 'config')

  _isSheetSaving: (row) ->
    sheetId = row.get('sheetId').toString()
    fileId = row.get('fileId').toString()
    @props.savingSheets and @props.savingSheets.hasIn([fileId, sheetId])
