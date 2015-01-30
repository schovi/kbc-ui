React = require('react')
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin.coffee'

Link = React.createFactory(require('react-router').Link)
#QueryDeleteButton = React.createFactory(require('../../components/QueryDeleteButton.coffee'))

{i, span, div, a, strong} = React.DOM

module.exports = React.createClass
  displayName: 'ItemsTable'
  mixins: [ImmutableRenderMixin]
  propTypes:
    items: React.PropTypes.object
    #configurationId: number


  _rawConfig: (row) ->
    JSON.parse(row.get 'config')

  render: ->
    childs = @props.items.map((row, rowkey) ->
      Link
        className: 'tr'
        to: 'ex-google-drive-sheet'
        params:
          config: @props.configurationId
          sheetId: rowkey
        div className: 'td', row.get 'title'
        div className: 'td', row.get 'sheetTitle'
        div className: 'td',
          i className: 'fa fa-fw fa-long-arrow-right'
        div className: 'td', @_rawConfig(row)?.db?.table or "n/a"
        div className: 'td', "todo:delete play"

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
            strong null, 'SAPI Table'
          span className: 'th' #actions buttons
      div className: 'tbody',
        childs
