React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TransformationsActionCreators = require '../../../ActionCreators'

DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')

InputMappingRow = React.createFactory(require './InputMappingRow')
InputMappingDetail = React.createFactory(require './InputMappingDetail')
OutputMappingRow = React.createFactory(require './OutputMappingRow')
OutputMappingDetail = React.createFactory(require './OutputMappingDetail')
CodeMirror = React.createFactory(require 'react-code-mirror')
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')
GraphContainer = React.createFactory(require './GraphContainer')
{Panel} = require('react-bootstrap')
Panel  = React.createFactory Panel
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
SqlDepModalTrigger = React.createFactory(require '../../modals/SqlDepModalTrigger.coffee')

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')

{div, span, input, strong, form, button, h2, i, ul, li, button, a, small, p, code, em} = React.DOM

TransformationDetailStatic = React.createClass
  displayName: 'TransformationDetailStatic'

  mixins: [ImmutableRenderMixin]

  propTypes:
    bucket: React.PropTypes.object.isRequired
    transformation: React.PropTypes.object.isRequired
    pendingActions: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    bucketId: React.PropTypes.string.isRequired
    transformationId: React.PropTypes.string.isRequired
    openInputMappings: React.PropTypes.object.isRequired
    openOutputMappings: React.PropTypes.object.isRequired
    showDetails: React.PropTypes.bool.isRequired

  _toggleInputMapping: (index) ->
    TransformationsActionCreators.toggleOpenInputMapping(@props.bucketId, @props.transformationId, index)

  _toggleOutputMapping: (index) ->
    TransformationsActionCreators.toggleOpenOutputMapping(@props.bucketId, @props.transformationId, index)

  _renderDetail: ->
    props = @props
    component = @
    span {},
      div {},
        h2 {}, 'Input Mapping'
        if @props.transformation.get('input').count()
          div {},
            @props.transformation.get('input').sortBy((inputMapping) ->
              inputMapping.get('source').toLowerCase()
            ).map((input, key) ->
              Panel
                className: 'kbc-panel-heading-with-table'
                key: key
                collapsible: true
                eventKey: key
                expanded: props.openInputMappings.get(key, false)
                header:
                  div
                    onClick: ->
                      component._toggleInputMapping(key)
                  ,
                    InputMappingRow
                      transformationBackend: @props.transformation.get('backend')
                      inputMapping: input
                      tables: @props.tables
              ,
                InputMappingDetail
                  fill: true
                  transformationBackend: @props.transformation.get('backend')
                  inputMapping: input
                  tables: @props.tables
            , @).toArray()
        else
          p {}, small {}, 'No Input Mapping'
      div {},
        h2 {}, 'Output Mapping'
          if @props.transformation.get('output').count()
            div {},
              @props.transformation.get('output').sortBy((outputMapping) ->
                outputMapping.get('source').toLowerCase()
              ).map((output, key) ->
                Panel
                  className: 'kbc-panel-heading-with-table'
                  key: key
                  collapsible: true
                  eventKey: key
                  expanded: props.openOutputMappings.get(key, false)
                  header:
                    div
                      onClick: ->
                        component._toggleOutputMapping(key)
                    ,
                      OutputMappingRow
                        transformationBackend: @props.transformation.get('backend')
                        outputMapping: output
                        tables: @props.tables
                ,
                  OutputMappingDetail
                    fill: true
                    transformationBackend: @props.transformation.get('backend')
                    outputMapping: output
                    tables: @props.tables

              , @).toArray()
          else
            p {}, small {}, 'No Output Mapping'

      if @props.transformation.get('backend') == 'docker' && @props.transformation.get('type') == 'r'
        div {},
          h2 {}, 'Packages'
          p {},
            if @props.transformation.get('packages', Immutable.List()).count()
              @props.transformation.get('packages', Immutable.List()).map((packageName, key) ->
                span {key: key},
                  span {className: 'label label-default'},
                    packageName
                  ' '
              , @).toArray()
            else
              small {},
              'No packages will installed'

          if @props.transformation.get('packages', Immutable.List()).count()
            p {}, small {},
                'These packages will be installed into the Docker container running the R script. '
                'Do not forget to load them using '
                code {}, 'library()'
                '.'

      if @props.transformation.get('backend') == 'docker' && @props.transformation.get('type') == 'r'
        div {},
          h2 {}, 'Script'
          if @props.transformation.get('queries').count()
            CodeMirror
              theme: 'solarized'
              lineNumbers: true
              defaultValue: @props.transformation.getIn ['queries', 0]
              readOnly: true
              mode: 'text/x-rsrc'
              lineWrapping: true
          else
            p {}, small {}, 'No R Script'
      else
        div {},
          h2 {}, 'Queries'
          if @props.transformation.get('queries').count()
            span {},
              @props.transformation.get('queries').map((query, index) ->
                if index % 2 == 0
                  rowClassName = "row stripe-odd"
                else
                  rowClassName = "row"
                div {className: rowClassName, key: index},
                  div {className: 'col-md-1 vertical-center', key: "number"},
                    index + 1
                  div {className: 'col-md-11 vertical-center', key: "query"},
                    span {className: 'static'},
                      CodeMirror
                        theme: 'solarized'
                        lineNumbers: false
                        defaultValue: query
                        readOnly: true
                        mode: @_codeMirrorMode()
                        lineWrapping: true
              , @).toArray()
              if @props.transformation.get('backend') == 'redshift' or
                  @props.transformation.get('backend') == 'mysql' &&
                  @props.transformation.get('type') == 'simple'
                SqlDepModalTrigger
                  backend: @props.transformation.get('backend')
                  bucketId: @props.bucketId
                  transformationId: @props.transformationId
                ,
                  a {},
                    span className: 'fa fa-sitemap fa-fw'
                    ' SQLDep'
          else
            p {}, small {}, 'No SQL Queries'

  render: ->
    props = @props
    component = @
    div {},
      div className: 'kbc-row kbc-header',
        @props.transformation.get("description") || em {}, "No description ..."
      div className: '',
        div {className: 'kbc-row'},
          div {className: 'pull-right'},
            span {className: 'label kbc-label-rounded-small label-default'},
              'Phase: '
              @props.transformation.get 'phase'
            ' '
            TransformationTypeLabel
              backend: @props.transformation.get 'backend'
              type: @props.transformation.get 'type'
          h2 {}, 'Overview'
          GraphContainer
            bucketId: @props.bucketId
            transformationId: @props.transformationId
            disabled: @props.transformation.get("disabled", false)
          span {},
            if !@props.showDetails
              div {className: 'well'},
                "This transformation is not supported in UI."
          span {},
            if @props.showDetails
              @_renderDetail()

  _codeMirrorMode: ->
    mode = 'text/text'
    if @props.transformation.get('backend') == 'mysql'
      mode = 'text/x-mysql'
    else if @props.transformation.get('backend') == 'redshift'
      mode = 'text/x-sql'
    else if @props.transformation.get('backend') == 'docker' && @props.transformation.get('type') == 'r'
      mode = 'text/x-rsrc'
    return mode

module.exports = TransformationDetailStatic
