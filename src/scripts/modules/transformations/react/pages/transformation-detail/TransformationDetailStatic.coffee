React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')
{Map, List} = Immutable
Clipboard = React.createFactory(require '../../../../../react/common/Clipboard')
_ = require('underscore')

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
TransformationsActionCreators = require '../../../ActionCreators'

DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')

InputMappingRow = React.createFactory(require './InputMappingRow')
InputMappingDetail = React.createFactory(require './InputMappingDetail')
OutputMappingRow = React.createFactory(require './OutputMappingRow')
OutputMappingDetail = React.createFactory(require './OutputMappingDetail')
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require('../../../../../react/common/ActivateDeactivateButton').default)
{Panel, ModalTrigger} = require('react-bootstrap')
Panel  = React.createFactory Panel
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')
SqlDepModalTrigger = React.createFactory(require '../../modals/SqlDepModalTrigger.coffee')
Requires = require('./Requires').default
Packages = require('./Packages').default
SavedFiles = require('./SavedFiles').default
Queries = require('./Queries').default
Scripts = require('./Scripts').default
Phase = require('./Phase').default
AddOutputMapping = require('./AddOutputMapping').default
AddInputMapping = require('./AddInputMapping').default
InlineEditArea = require '../../../../../react/common/InlineEditArea'


{div, span, input, strong, form, button, h2, i, ul, li, button, a, small, p, code, em} = React.DOM

module.exports = React.createClass
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

  _inputMappingDestinations: (exclude) ->
    @props.transformation.get("input", Map()).map((mapping, key) ->
      if key != exclude
        return mapping.get("destination").toLowerCase()
    ).filter((destination) ->
      destination != undefined
    )

  _renderRequires: ->
    span {},
      h2 {}, 'Requires'
      React.createElement Requires,
        bucketId: @props.bucket.get('id')
        transformation: @props.transformation
        transformations: @props.transformations
        isEditing: @props.editingFields.has('requires')
        isSaving: @props.pendingActions.has('save-requires')
        requires: @props.editingFields.get('requires', @props.transformation.get("requires"))
        onEditStart: =>
          TransformationsActionCreators.startTransformationFieldEdit(@props.bucketId,
            @props.transformationId, 'requires')
        onEditCancel: =>
          TransformationsActionCreators.cancelTransformationEditingField(@props.bucketId,
            @props.transformationId, 'requires')
        onEditChange: (newValue) =>
          TransformationsActionCreators.updateTransformationEditingField(@props.bucketId,
            @props.transformationId, 'requires', newValue)
        onEditSubmit: =>
          TransformationsActionCreators.saveTransformationEditingField(@props.bucketId,
            @props.transformationId, 'requires')
      span {},
        div {},
          h2 {}, 'Dependent transformations'
          if @_getDependentTransformations().count()
            span {},
              div {className: "help-block"}, small {},
                "These transformations are dependent on the current transformation."
              div {},
                @_getDependentTransformations().map((dependent) ->
                  Link
                    key: dependent.get("id")
                    to: 'transformationDetail'
                    params: {transformationId: dependent.get("id"), configId: @props.bucket.get('id')}
                  ,
                    span {className: 'label kbc-label-rounded-small label-default'},
                      dependent.get("name")
                , @).toArray()
          else
            div {className: "help-block"}, small {},
              "No transformations are dependent on the current transformation."

  _renderDetail: ->
    props = @props
    component = @
    div {className: 'kbc-row'},
      if @props.transformation.get('backend') != 'docker'
        @_renderRequires()
      div {},
        h2 {},
          'Input Mapping'
          if @props.transformation.get('input').count() >= 1
            span className: 'pull-right',
              React.createElement AddInputMapping,
                tables: @props.tables
                transformation: @props.transformation
                bucket: @props.bucket
                mapping: @props.editingFields.get('new-input-mapping', Map())
                otherDestinations: @_inputMappingDestinations()
        if @props.transformation.get('input').count()
          div {},
            @props.transformation.get('input').map((input, key) ->
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
                      otherDestinations: @_inputMappingDestinations(key)
              ,
                InputMappingDetail
                  fill: true
                  transformationBackend: @props.transformation.get('backend')
                  inputMapping: input
                  tables: @props.tables
            , @).toArray()
        else
          div {className: "well text-center"},
            p {}, 'No inputs assigned yet.'
            React.createElement AddInputMapping,
              tables: @props.tables
              transformation: @props.transformation
              bucket: @props.bucket
              mapping: @props.editingFields.get('new-input-mapping', Map())
              otherDestinations: @_inputMappingDestinations()
      div {},
        h2 {},
          'Output Mapping'
          if  @props.transformation.get('output').count() >= 1
            span className: 'pull-right',
              React.createElement AddOutputMapping,
                tables: @props.tables
                buckets: @props.buckets
                transformation: @props.transformation
                bucket: @props.bucket
                mapping: @props.editingFields.get('new-output-mapping', Map())
        if @props.transformation.get('output').count()
          div {},
            @props.transformation.get('output').map((output, key) ->
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
                      buckets: @props.buckets
              ,
                OutputMappingDetail
                  fill: true
                  transformationBackend: @props.transformation.get('backend')
                  outputMapping: output
                  tables: @props.tables

            , @).toArray()
        else
          div {className: "well text-center"},
            p {}, 'No Output Mapping assigned yet.'
            React.createElement AddOutputMapping,
              tables: @props.tables
              buckets: @props.buckets
              transformation: @props.transformation
              bucket: @props.bucket
              mapping: @props.editingFields.get('new-output-mapping', Map())

      if @props.transformation.get('backend') == 'docker'
        div {},
          h2 {}, 'Packages'
          React.createElement Packages,
            bucketId: @props.bucket.get('id')
            transformation: @props.transformation
            transformations: @props.transformations
            isEditing: @props.editingFields.has('packages')
            isSaving: @props.pendingActions.has('save-packages')
            packages: @props.editingFields.get('packages', @props.transformation.get("packages", List()))
            onEditStart: =>
              TransformationsActionCreators.startTransformationFieldEdit(@props.bucketId,
                @props.transformationId, 'packages')
            onEditCancel: =>
              TransformationsActionCreators.cancelTransformationEditingField(@props.bucketId,
                @props.transformationId, 'packages')
            onEditChange: (newValue) =>
              TransformationsActionCreators.updateTransformationEditingField(@props.bucketId,
                @props.transformationId, 'packages', newValue)
            onEditSubmit: =>
              TransformationsActionCreators.saveTransformationEditingField(@props.bucketId,
                @props.transformationId, 'packages')
      if @props.transformation.get('backend') == 'docker'
        div {},
          h2 {}, 'Stored Files'
          React.createElement SavedFiles,
            bucketId: @props.bucket.get('id')
            isEditing: @props.editingFields.has('tags')
            isSaving: @props.pendingActions.has('save-tags')
            tags: @props.editingFields.get('tags', @props.transformation.get("tags", List()))
            onEditStart: =>
              TransformationsActionCreators.startTransformationFieldEdit(@props.bucketId,
                @props.transformationId, 'tags')
            onEditCancel: =>
              TransformationsActionCreators.cancelTransformationEditingField(@props.bucketId,
                @props.transformationId, 'tags')
            onEditChange: (newValue) =>
              TransformationsActionCreators.updateTransformationEditingField(@props.bucketId,
                @props.transformationId, 'tags', newValue)
            onEditSubmit: =>
              TransformationsActionCreators.saveTransformationEditingField(@props.bucketId,
                @props.transformationId, 'tags')

      @_renderCodeEditor()

  _renderCodeEditor: ->
    if  @props.transformation.get('backend') == 'docker'
      element = Scripts
    else
      element = Queries

    React.createElement element,
      bucketId: @props.bucket.get('id')
      transformation: @props.transformation
      isEditing: @props.editingFields.has('queriesString')
      isSaving: @props.pendingActions.has('save-queriesString')
      queries: @props.editingFields.get('queriesString', @props.transformation.get("queriesString"))
      scripts: @props.editingFields.get('queriesString', @props.transformation.get("queriesString"))
      onEditStart: =>
        TransformationsActionCreators.startTransformationFieldEdit(@props.bucketId,
          @props.transformationId, 'queriesString')
      onEditCancel: =>
        TransformationsActionCreators.cancelTransformationEditingField(@props.bucketId,
          @props.transformationId, 'queriesString')
      onEditChange: (newValue) =>
        TransformationsActionCreators.updateTransformationEditingField(@props.bucketId,
          @props.transformationId, 'queriesString', newValue)
      onEditSubmit: =>
        if  @props.transformation.get('backend') == 'docker'
          changeDescription = 'Change Script in ' + @props.transformation.get('name')
        else
          changeDescription = 'Change Queries in ' + @props.transformation.get('name')
        TransformationsActionCreators.saveTransformationEditingField(@props.bucketId,
          @props.transformationId, 'queriesString', changeDescription)

  render: ->
    div {},
      div className: 'kbc-row kbc-header',
        div className: 'col-xs-8',
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
        div {className: 'col-xs-4'},
          div className: 'pull-right',
            React.createElement Phase,
              bucketId: @props.bucketId
              transformation: @props.transformation
            ' '
            TransformationTypeLabel
              backend: @props.transformation.get 'backend'
              type: @props.transformation.get 'type'

      div className: '',
        if @props.showDetails
          @_renderDetail()
        else
          div {className: 'kbc-row'},
            div {className: 'well'},
              "This transformation is not supported in UI."
