React = require('react')
Link = React.createFactory(require('react-router').Link)
Router = require 'react-router'
Immutable = require('immutable')

createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
TransformationsStore  = require('../../../stores/TransformationsStore')
TransformationBucketsStore  = require('../../../stores/TransformationBucketsStore')
StorageTablesStore  = require('../../../../components/stores/StorageTablesStore')
RoutesStore = require '../../../../../stores/RoutesStore'
DeleteButton = React.createFactory(require '../../../../../react/common/DeleteButton')
TransformationsActionCreators = require '../../../ActionCreators'
InputMappingRow = React.createFactory(require './InputMappingRow')
InputMappingDetail = React.createFactory(require './InputMappingDetail')
OutputMappingRow = React.createFactory(require './OutputMappingRow')
OutputMappingDetail = React.createFactory(require './OutputMappingDetail')
CodeMirror = React.createFactory(require 'react-code-mirror')
RunComponentButton = React.createFactory(require '../../../../components/react/components/RunComponentButton')
ActivateDeactivateButton = React.createFactory(require '../../../../../react/common/ActivateDeactivateButton')
GraphContainer = require './GraphContainer'
{Panel, Accordion} = require('react-bootstrap')
Panel  = React.createFactory Panel
Accordion = React.createFactory Accordion
{Tooltip, Confirm, Loader} = require '../../../../../react/common/common'
TransformationTypeLabel = React.createFactory(require '../../components/TransformationTypeLabel')

require('codemirror/mode/sql/sql')
require('codemirror/mode/r/r')

{div, span, input, strong, form, button, h4, i, ul, li, button, a, small, p} = React.DOM

TransformationDetail = React.createClass
  displayName: 'TransformationDetail'
  mixins: [
    createStoreMixin(TransformationsStore, TransformationBucketsStore, StorageTablesStore),
    Router.Navigation
  ]
  getStateFromStores: ->
    bucketId = RoutesStore.getCurrentRouteParam 'bucketId'
    transformationId = RoutesStore.getCurrentRouteParam 'transformationId'
    bucket: TransformationBucketsStore.get(bucketId)
    transformation: TransformationsStore.getTransformation(bucketId, transformationId)
    pendingActions: TransformationsStore.getPendingActions(bucketId)
    tables: StorageTablesStore.getAll()

  render: ->
    state = @state
    div className: 'container-fluid',
      div className: 'col-md-9 kbc-main-content',
        div className: 'row kbc-header',
          @state.transformation.get 'description'
          span {className: 'pull-right'},
            span {className: 'label kbc-label-rounded-small label-default'},
              @state.transformation.get 'phase'
            ' '
            TransformationTypeLabel
              backend: @state.transformation.get 'backend'
              type: @state.transformation.get 'type'


          #TransformationDescription
          #  bucketId: @state.bucket.get 'id'
          #  transformation: @state.transformation.get 'id'
        p {},
          h4 {}, 'Overview'
          GraphContainer transformation: @state.transformation
        p {},
          h4 {}, 'Input Mapping'
          if @state.transformation.get('input').count()
            Accordion {},
              @state.transformation.get('input').sortBy((inputMapping) ->
                inputMapping.get('source').toLowerCase()
              ).map((input, key) ->
                Panel
                  header:
                    span {},
                      InputMappingRow
                        transformationBackend: @state.transformation.get('backend')
                        inputMapping: input
                        tables: @state.tables
                  eventKey: key
                ,
                  InputMappingDetail
                    transformationBackend: @state.transformation.get('backend')
                    inputMapping: input
                    tables: @state.tables

              , @).toArray()
          else
            p {}, small {}, 'No Input Mapping'
        p {},
          h4 {}, 'Output Mapping'
            if @state.transformation.get('output').count()
              Accordion {},
                @state.transformation.get('output').sortBy((outputMapping) ->
                  outputMapping.get('source').toLowerCase()
                ).map((output, key) ->
                  Panel
                    header:
                      span {},
                        OutputMappingRow
                          transformationBackend: @state.transformation.get('backend')
                          outputMapping: output
                          tables: @state.tables
                    eventKey: key
                  ,
                    OutputMappingDetail
                      transformationBackend: @state.transformation.get('backend')
                      outputMapping: output
                      tables: @state.tables

                , @).toArray()
            else
              p {}, small {}, 'No Output Mapping'

        if @state.transformation.get('backend') == 'docker' && @state.transformation.get('type') == 'r'
          p {},
            h4 {}, 'Script'
            if @state.transformation.get('items').count()
              CodeMirror
                theme: 'solarized'
                lineNumbers: true
                defaultValue: @state.transformation.getIn ['items', 0, 'query']
                readOnly: true
                mode: 'text/x-rsrc'
                lineWrapping: true
            else
              small {}, 'No R Script'
        else
          p {},
            h4 {}, 'Queries'
            if @state.transformation.get('items').count()
              mode = 'text/text'
              if @state.transformation.get('backend') == 'db'
                mode = 'text/x-mysql'
              else if @state.transformation.get('backend') == 'redshift'
                mode = 'text/x-sql'
              else if @state.transformation.get('backend') == 'docker' && @state.transformation.get('type') == 'r'
                mode = 'text/x-rsrc'
              div className: 'table table-striped table-hover',
                span {className: 'tbody'},
                  @state.transformation.get('items').map((item, index) ->
                    span {className: 'tr'},
                      span {className: 'td'},
                        index + 1
                      span {className: 'td'},
                        span {className: 'static'},
                          CodeMirror
                            theme: 'solarized'
                            lineNumbers: false
                            defaultValue: item.get 'query'
                            readOnly: true
                            mode: mode
                            lineWrapping: true
                  , @).toArray()
            else
              small {}, 'No SQL Queries'

      div className: 'col-md-3 kbc-main-sidebar',
        ul className: 'nav nav-stacked',
          li {},
            RunComponentButton(
              title: "Run Transformation"
              component: 'transformation'
              mode: 'link'
              runParams: ->
                configBucketId: state.bucket.get('id')
                transformations: [state.transformation.get('id')]
            ,
              "You are about to run transformation #{@state.transformation.get('friendlyName')}."
            )
          li {},
            ActivateDeactivateButton
              mode: 'link'
              activateTooltip: 'Enable Transformation'
              deactivateTooltip: 'Disable Transformation'
              isActive: !parseInt(@state.transformation.get('disabled'))
              isPending: @state.pendingActions.get('save')
              onChange: ->

          li {},
            a {},
              span className: 'fa fa-sitemap fa-fw'
              ' SQLDep'

          li {},
            a {},
              Confirm
                text: 'Delete Transformation'
                title: "Do you really want to delete transformation #{@state.transformation.get('friendlyName')}?"
                buttonLabel: 'Delete'
                buttonType: 'danger'
                onConfirm: @_deleteTransformation
              ,
                span {},
                  span className: 'fa kbc-icon-cup fa-fw'
                  ' Delete transformation'

  _deleteTransformation: ->
    transformationId = @state.transformation.get('id')
    bucketId = @state.bucket.get('id')
    TransformationsActionCreators.deleteTransformation(bucketId, transformationId)
    @transitionTo 'transformationBucket',
      bucketId: bucketId

module.exports = TransformationDetail
