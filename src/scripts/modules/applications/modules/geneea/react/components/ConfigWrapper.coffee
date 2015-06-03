React = require 'react'
{span, div, a, p, h2, table, tbody, tr, ul, td, small, li} = React.DOM
ComponentIcon = React.createFactory(require '../../../../../../react/common/ComponentIcon')
Link = React.createFactory require('react-router').Link

module.exports = React.createClass

  displayName: 'GeneeaAppCompoonentWrapper'

  propTypes:
    installedConfigurations: React.PropTypes.object.isRequired

  render: ->
    div className: 'container-fluid kbc-main-content',
      table className: 'table table-bordered kbc-table-full-width kbc-components-list',
        tbody null, @renderComponentRow(@props.installedConfigurations)


  renderComponentRow: (component) ->
    tr key: component.get('id'),
      td null,
        ComponentIcon
          component: component
          size: '32'
        component.get('name')
      td null, @renderConfigs(component)


  renderConfigs: (component) ->
    ul null,
      component.get('configurations').map((config) ->
        console.log "configs", config.get 'id'
        li key: config.get('id'),
          Link
            to: "kbc-app-geneea-detail"
            params:
              config: config.get 'id'
          ,
            span className: 'kbc-config-name',
              if config.get 'name'
                config.get 'name'
              else
                '---'
            if config.get 'description'
              small null, config.get('description')
          span className: 'kbc-icon-arrow-right'

      ).toArray()
