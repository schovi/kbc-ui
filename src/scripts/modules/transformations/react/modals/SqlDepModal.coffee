React = require 'react'

Modal = React.createFactory(require('react-bootstrap').Modal)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
api = require '../../TransformationsApi'
Loader = React.createFactory(require('../../../../react/common/Loader'))
_ = require('underscore')
Immutable = require 'immutable'
List = Immutable.List

{div, p, a, strong, code, span, h4} = React.DOM


SqlDepModal = React.createClass
  displayName: 'SqlDepModal'

  getInitialState: ->
    isLoading: true
    sqlDepUrl: null
    warnings: List()

  componentDidMount: ->
    if (@props.backend == 'redshift')
      component = @
      api
      .getSqlDep(
        configBucketId: @props.bucketId
        transformations: [@props.transformationId]
      )
      .then((response) ->
        component.setState
          isLoading: false
          sqlDepUrl: response.url
          warnings: Immutable.fromJS(response.warnings)
      )

  render: ->
    if @props.backend == 'redshift'
      @_renderAvailable()
    else
      @_renderNotAvailable()

  _renderAvailable: ->
    Modal title: 'SQLDep', onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        if @state.isLoading
          p null,
            Loader {}
            ' '
            'Loading SQLdep data. This may take a minute or two...'
        else if !@state.isLoading && @state.warnings.count() > 0
          span {},
            p {},
              'SQLdep was processed, but the transformation contained some errors.'
            p {},
              a {href: @state.sqlDepUrl},
                'Open SQLDep'
            h4 {},
              'Errors'
            @state.warnings.map((warning) ->
              p {},
                div {},
                  strong {},
                    warning.getIn ['query', 'name']
                div {},
                  '['
                  warning.get 'processStatusCode'
                  '] '
                  warning.get 'processStatusDesc'
                div {},
                  code {},
                    warning.getIn ['query', 'sourceCode']
            ).toArray()
        else
          span {},
            p {},
              'SQLdep is ready.'
            p {},
              a {href: @state.sqlDepUrl},
                'Open SQLDep'

      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Close'

  _renderNotAvailable: ->
    Modal title: 'SQLDep', onRequestHide: @props.onRequestHide,
      div className: 'modal-body',
        p {},
          'Visual SQL analysis is available for Redshift transformations only.'
        p {},
          'Contact '
          a {href: 'mailto:support@keboola.com'}, 'support@keboola.com'
          'for more information.'
      div className: 'modal-footer',
        ButtonToolbar null,
          Button
            onClick: @props.onRequestHide
            bsStyle: 'link'
          ,
            'Close'

  _handleConfirm: ->
    @props.onRequestHide()
    @props.onConfirm()

module.exports = SqlDepModal
