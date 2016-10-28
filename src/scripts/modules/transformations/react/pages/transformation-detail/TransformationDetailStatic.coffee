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

{getInputMappingValue, getOutputMappingValue,
  findInputMappingDefinition, findOutputMappingDefinition} = require('../../../../components/utils/mappingDefinitions')


{div, span, input, strong, form, button, h2, i, ul, li, button, a, small, p, code, em} = React.DOM

module.exports = React.createClass
  displayName: 'TransformationDetailStatic'

  mixins: [ImmutableRenderMixin]

  propTypes:
    bucket: React.PropTypes.object.isRequired
    transformation: React.PropTypes.object.isRequired
    editingFields: React.PropTypes.object.isRequired
    isEditingQueriesValid: React.PropTypes.bool.isRequired
    transformations: React.PropTypes.object.isRequired
    pendingActions: React.PropTypes.object.isRequired
    tables: React.PropTypes.object.isRequired
    buckets: React.PropTypes.object.isRequired
    bucketId: React.PropTypes.string.isRequired
    transformationId: React.PropTypes.string.isRequired
    openInputMappings: React.PropTypes.object.isRequired
    openOutputMappings: React.PropTypes.object.isRequired
    showDetails: React.PropTypes.bool.isRequired

  # TODO move this to component definition UI Options
  openRefine:
    inputMappingDefinitions: Immutable.fromJS([
      {
        'label': 'Load data from table',
        'destination': 'data.csv'
      }
    ])
    outputMappingDefinitions: Immutable.fromJS([
      {
        'label': 'Save result to table',
        'source': 'data.csv'
      }
    ])

  _isOpenRefineTransformation: ->
    @props.transformation.get("backend") == "docker" && @props.transformation.get("type") == "openrefine"

  _getInputMappingValue: ->
    value = @props.transformation.get("input", List())
    if (@_isOpenRefineTransformation())
      return getInputMappingValue(@openRefine.inputMappingDefinitions, value)
    return value

  _getOutputMappingValue: ->
    value = @props.transformation.get("output", List())
    if (@_isOpenRefineTransformation())
      return getOutputMappingValue(@openRefine.outputMappingDefinitions, value)
    return value

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
    @_getInputMappingValue().map((mapping, key) ->
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
                    params: {row: dependent.get("id"), config: @props.bucket.get('id')}
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
    span null,
      div {className: 'kbc-row'},
        p className: 'text-right',
          React.createElement Phase,
            bucketId: @props.bucketId
            transformation: @props.transformation
          ' '
          TransformationTypeLabel
            backend: @props.transformation.get 'backend'
            type: @props.transformation.get 'type'

        if @_isOpenRefineTransformation()
          [
            h2 {},
              'OpenRefine Beta Warning'

            div {className: "help-block"},
              span {},
                'OpenRefine transformations are now in public beta. '
                'Please be aware, that things may change before it makes to production. '
                'If you encounter any errors, please contact us at '
                a {href: "mailto:support@keboola.com"},
                  'support@keboola.com'
                ' or read more in the '
                a {href: "https://help.keboola.com/manipulation/transformations/openrefine/"},
                  'documentation'
                '.'
          ]

        React.createElement InlineEditArea,
          isEditing: @props.editingFields.has('description')
          isSaving: @props.pendingActions.has('save-description')
          text: @props.editingFields.get('description', @props.transformation.get("description"))
          editTooltip: "Click to edit description"
          placeholder: "Describe transformation"
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

      div {className: 'kbc-row'},

        if @props.transformation.get('backend') != 'docker'
          @_renderRequires()
        div {},
          h2 {},
            'Input Mapping'
            if @_getInputMappingValue().count() >= 1 && !@_isOpenRefineTransformation()
              span className: 'pull-right',
                React.createElement AddInputMapping,
                  tables: @props.tables
                  transformation: @props.transformation
                  bucket: @props.bucket
                  mapping: @props.editingFields.get('new-input-mapping', Map())
                  otherDestinations: @_inputMappingDestinations()
          if @_getInputMappingValue().count()
            div {},
              @_getInputMappingValue().map((input, key) ->
                if (@_isOpenRefineTransformation())
                  definition = findInputMappingDefinition(@openRefine.inputMappingDefinitions, input)
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
                        definition: definition
                ,
                  InputMappingDetail
                    fill: true
                    transformationBackend: @props.transformation.get('backend')
                    inputMapping: input
                    tables: @props.tables
                    definition: definition
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
            if  @_getOutputMappingValue().count() >= 1 && !@_isOpenRefineTransformation()
              span className: 'pull-right',
                React.createElement AddOutputMapping,
                  tables: @props.tables
                  buckets: @props.buckets
                  transformation: @props.transformation
                  bucket: @props.bucket
                  mapping: @props.editingFields.get('new-output-mapping', Map())
          if @_getOutputMappingValue().count()
            div {},
              @_getOutputMappingValue().map((output, key) ->
                if (@_isOpenRefineTransformation())
                  definition = findOutputMappingDefinition(@openRefine.outputMappingDefinitions, output)
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
                        definition: definition
                ,
                  OutputMappingDetail
                    fill: true
                    transformationBackend: @props.transformation.get('backend')
                    outputMapping: output
                    tables: @props.tables

              , @).toArray()
          else
            div {className: "well text-center"},
              p {}, 'No outputs assigned yet.'
              React.createElement AddOutputMapping,
                tables: @props.tables
                buckets: @props.buckets
                transformation: @props.transformation
                bucket: @props.bucket
                mapping: @props.editingFields.get('new-output-mapping', Map())

        if @props.transformation.get('backend') == 'docker' && @props.transformation.get('type') != 'openrefine'
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
        if @props.transformation.get('backend') == 'docker' && @props.transformation.get('type') != 'openrefine'
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
      isEditingValid: @props.isEditingQueriesValid
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
    div null,
      if @props.showDetails
        @_renderDetail()
      else
        div {className: 'kbc-row'},
          div {className: 'well'},
            "This transformation is not supported in UI."
