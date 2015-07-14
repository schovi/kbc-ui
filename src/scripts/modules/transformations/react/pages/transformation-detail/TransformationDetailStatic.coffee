React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')
{Map} = Immutable
Clipboard = React.createFactory(require '../../../../../react/common/Clipboard')
_ = require('underscore')

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
{Panel, ModalTrigger} = require('react-bootstrap')
Panel  = React.createFactory Panel
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
SqlDepModalTrigger = React.createFactory(require '../../modals/SqlDepModalTrigger.coffee')
SelectRequires = React.createFactory(require('./SelectRequires'))
{NewLineToBr} = require 'kbc-react-components'
AddOutputMapping = require './AddOutputMapping'
AddInputMapping = require './AddInputMapping'
InlineEditArea = require '../../../../../react/common/InlineEditArea'

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')

{div, span, input, strong, form, button, h2, i, ul, li, button, a, small, p, code, em} = React.DOM

TransformationDetailStatic = React.createClass
  displayName: 'TransformationDetailStatic'

  mixins: [ImmutableRenderMixin]

  propTypes:
    bucket: React.PropTypes.object.isRequired
    transformation: React.PropTypes.object.isRequired
    editingFields: React.PropTypes.object.isRequired
    transformations: React.PropTypes.object.isRequired
    pendingActions: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    buckets: React.PropTypes.object.isRequired
    bucketId: React.PropTypes.string.isRequired
    transformationId: React.PropTypes.string.isRequired
    openInputMappings: React.PropTypes.object.isRequired
    openOutputMappings: React.PropTypes.object.isRequired
    showDetails: React.PropTypes.bool.isRequired

  _toggleInputMapping: (index) ->
    TransformationsActionCreators.toggleOpenInputMapping(@props.bucketId, @props.transformationId, index)

  _toggleOutputMapping: (index) ->
    TransformationsActionCreators.toggleOpenOutputMapping(@props.bucketId, @props.transformationId, index)

  _getDependentTransformations: ->
    props = @props
    @props.transformations.filter((transformation) ->
      transformation.get("requires").contains(props.transformation.get("id"))
    )

  _renderDetail: ->
    props = @props
    component = @
    div {className: 'kbc-row'},
      h2 {}, 'Requires'
      if @props.transformation.get("requires").toArray().length
        span {},
          div {className: "help-block"}, small {},
            "These transformations are processed before this transformation starts."
          div {},
            _.map(@props.transformation.get("requires").toArray(), (required) ->
              Link
                to: 'transformationDetail'
                params: {transformationId: required, bucketId: props.bucket.get('id')}
              ,
                span {className: 'label kbc-label-rounded-small label-default'},
                  _.find(props.transformations.toArray(), (transformation) ->
                    transformation.get("id") == required
                  )?.get("name") || required
            )
      else
        div {className: "help-block"}, small {},
          "No transformations are required."

      span {},
        div {},
          h2 {}, 'Dependent transformations'
          if @_getDependentTransformations().count()
            span {},
              div {className: "help-block"}, small {},
                "These transformations are dependent on the current transformation."
              div {},
                _.map(@_getDependentTransformations().toArray(), (dependent) ->
                  Link
                    to: 'transformationDetail'
                    params: {transformationId: dependent.get("id"), bucketId: props.bucket.get('id')}
                  ,
                    span {className: 'label kbc-label-rounded-small label-default'},
                      dependent.get("name")
                )
          else
            div {className: "help-block"}, small {},
              "No transformations are dependent on the current transformation."


      div {},
        h2 {},
          'Input Mapping'
          span className: 'pull-right',
            React.createElement AddInputMapping,
              tables: @props.tables
              transformation: @props.transformation
              bucket: @props.bucket
              mapping: @props.editingFields.get('new-input-mapping', Map())
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
                      transformation: @props.transformation
                      bucket: @props.bucket
                      inputMapping: input
                      tables: @props.tables
                      editingInputMapping: @props.editingFields.get('input-' + key, input)
                      editingId: 'input-' + key
                      mappingIndex: key
                      pendingActions: @props.pendingActions
              ,
                InputMappingDetail
                  fill: true
                  transformationBackend: @props.transformation.get('backend')
                  inputMapping: input
                  tables: @props.tables
            , @).toArray()
        else
          div {className: "help-block"}, small {}, 'No Input Mapping'
      div {},
        h2 {},
          'Output Mapping'
          span className: 'pull-right',
            React.createElement AddOutputMapping,
              tables: @props.tables
              buckets: @props.buckets
              transformation: @props.transformation
              bucket: @props.bucket
              mapping: @props.editingFields.get('new-output-mapping', Map())
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
                      transformation: @props.transformation
                      bucket: @props.bucket
                      outputMapping: output
                      editingOutputMapping: @props.editingFields.get('input-' + key, output)
                      editingId: 'input-' + key
                      mappingIndex: key
                      tables: @props.tables
                      pendingActions: @props.pendingActions
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
          h2 {},
            'Queries',
            if @props.transformation.get('queries').count()
              small {},
                Clipboard text: @props.transformation.get('queries').toArray().join("\n\n")
          if @props.transformation.get('queries').count()
            div {},
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
                        value: query
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
        React.createElement InlineEditArea,
          isEditing: @props.editingFields.has('description')
          isSaving: @props.pendingActions.has('save-description')
          text: @props.editingFields.get('description', @props.transformation.get("description"))
          editTooltip: "Click to edit description"
          placeholder: "Describe the transformation"
          onEditStart: =>
            TransformationsActionCreators.startTransformationFieldEdit(@props.bucketId,
              @props.transformationId, 'description')
          onEditCancel: =>
            TransformationsActionCreators.cancelTransformationEditingField(@props.bucketId,
              @props.transformationId, 'description')
          onEditChange: (newValue) =>
            TransformationsActionCreators.updateTransformationEditingField(@props.bucketId,
              @props.transformationId, 'description', newValue)
          onEditSubmit: =>
            TransformationsActionCreators.saveTransformationEditingField(@props.bucketId,
              @props.transformationId, 'description')
        div {className: 'pull-right'},
          span {className: 'label kbc-label-rounded-small label-default'},
            'Phase: '
            @props.transformation.get 'phase'
          ' '
          TransformationTypeLabel
            backend: @props.transformation.get 'backend'
            type: @props.transformation.get 'type'

      div className: '',
        if props.showDetails
          @_renderDetail()
        else
          div {className: 'kbc-row'},
            div {className: 'well'},
              "This transformation is not supported in UI."

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
