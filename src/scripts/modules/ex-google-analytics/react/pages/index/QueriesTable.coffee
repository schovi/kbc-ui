React = require('react')
Link = React.createFactory(require('react-router').Link)
Loader = React.createFactory(require '../../../../../react/common/Loader')
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
{i, span, div, a, strong} = React.DOM

module.exports = React.createClass
  displayName: 'QueriesTable'
  mixins: [ImmutableRenderMixin]
  propTypes:
    queries: React.PropTypes.object
    # configurationId: number


  render: ->
    children = @props.queries.map((row, queryName) =>
      Link
        className: 'tr'
        to: 'ex-google-analytics-query'
        key: queryName
        params:
          config: @props.configId
          name: queryName
        div className: 'td', row.get('metrics')
        div className: 'td', row.get 'dimensions'
        div className: 'td', 'filters'
        div className: 'td', 'profiles'
        div className: 'td',
          i className: 'fa fa-fw fa-long-arrow-right'
        div className: 'td', queryName
      ).toArray()

    div className: 'table table-striped table-hover',
      div className: 'thead', key: 'table-header',
        div className: 'tr',
          span className: 'th',
            strong null, 'Metrics'
          span className: 'th',
            strong null, 'Dimensions'
          span className: 'th',
            strong null, 'Filters'
          span className: 'th',
            strong null, 'Profile'
          span className: 'th',""# -> arrow
          span className: 'th',
            strong null, 'SAPI Table'
          span className: 'th' #actions buttons
      div className: 'tbody',
         children
