React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
Input = React.createFactory(require('react-bootstrap').Input)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)


Loader = React.createFactory(require '../../../../../react/common/Loader')
bucketsStore = require '../../../../components/stores/StorageBucketsStore'
storageActionCreators = require '../../../../components/StorageActionCreators'
analStore = require '../../../exGanalStore'
actionCreators = require '../../../exGanalActionCreators'
Typeahead = require '../../../../../react/common/Typeahead'

{div, p, strong, form, input, label, div} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalOptionsModal'
  mixins: [createStoreMixin(analStore, bucketsStore)]
  propTypes:
    configId: React.PropTypes.string.isRequired
    outputBucket: React.PropTypes.string.isRequired

  getInitialState: ->
    outputBucket: @props.outputBucket

  componentDidMount: ->
    storageActionCreators.loadBuckets()

  getStateFromStores: ->
    buckets = bucketsStore.getAll()
    buckets = buckets.filter( (bucket) ->
      bucket.get('stage') != 'sys').map( (value,key) ->
      return key)
    isLoadingBuckets: bucketsStore.getIsLoading()
    buckets: buckets
    optionsBuckets: buckets.map( (value, key) ->
      value: value
      label: value
      )
    isSavingBucket: analStore.isSavingBucket(@props.configId)

  render: ->
    Modal
      title: 'Options'
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        form className: 'form-horizontal',
          # Input
          #   label: 'Output Bucket'
          #   tooltip: 'Common destination bucket for every table in the configuration'
          #   type: 'text'
          #   value: @state.outputBucket
          #   labelClassName: 'col-xs-4'
          #   wrapperClassName: 'col-xs-8'
          #   onChange: (event) =>
          #     @setState
          #       outputBucket: event.target.value
          div className: 'form-group',
            label className: 'control-label col-xs-4', 'Outbucket'
            div className: 'col-xs-8',
              React.createElement Typeahead,
                value: @state.outputBucket
                onChange: (event) =>
                  @setState
                    outputBucket: event.target.value
                options: @state.buckets.toArray()

      div className: 'modal-footer',
        ButtonToolbar null,
          Loader() if @state.isSavingBucket
          Button
            onClick: @props.onRequestHide
            disabled: @state.isSavingBucket
            bsStyle: 'link'
          ,
            'Cancel'
          Button
            onClick: @_handleConfirm
            disabled: @state.isSavingBucket
            bsStyle: 'success'
          ,
            'Save'
  _handleConfirm: ->
    actionCreators.saveOutputBucket(@props.configId, @state.outputBucket).then  =>
      @props.onRequestHide()
