React = require 'react'
Modal = React.createFactory(require('react-bootstrap').Modal)
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
Input = React.createFactory(require('react-bootstrap').Input)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
fuzzy = require 'fuzzy'

Autosuggest = React.createFactory(require 'react-autosuggest')
Loader = React.createFactory(require('kbc-react-components').Loader)
bucketsStore = require '../../../../components/stores/StorageBucketsStore'
storageActionCreators = require '../../../../components/StorageActionCreators'
analStore = require '../../../exGanalStore'
actionCreators = require '../../../exGanalActionCreators'



{span, div, p, strong, form, input, label, div} = React.DOM

createGetSuggestions = (getOptions) ->
  (input, callback) ->
    suggestions = getOptions()
      .filter (value) -> fuzzy.match(input, value)
      .toList()
    callback(null, suggestions.toJS())

module.exports = React.createClass
  displayName: 'ExGanalOptionsModal'
  mixins: [createStoreMixin(analStore, bucketsStore)]
  propTypes:
    configId: React.PropTypes.string.isRequired
    outputBucket: React.PropTypes.string.isRequired

  getInitialState: ->
    outputBucket: @props.outputBucket
    error: null

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
    helpBlock = span className: 'help-block',
      p className: 'text-danger',
        @state.error
    Modal
      title: 'Options'
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        div className: 'form-horizontal',
          div className: 'form-group',
            label className: 'control-label col-xs-2', 'Outbucket'
            div className: "col-xs-10 form-group",
              Autosuggest
                suggestions: createGetSuggestions(@_getBuckets)
                inputAttributes:
                  className: 'form-control'
                  placeholder: 'to get hint start typing'
                  value: @state.outputBucket
                  onChange: (newValue) =>
                    @_validate newValue
                    @setState
                      outputBucket: newValue
              helpBlock if @state.error

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
            disabled: @state.isSavingBucket or @state.error
            bsStyle: 'success'
          ,
            'Save'

  _validate: (newValue) ->
    error = null
    if not newValue or newValue == ''
      error = 'Can not be empty.'
    else
      stage = newValue.split('.')[0]
      if stage not in ['out', 'in']
        error = "Stage must be of type 'in' or 'out'"
    @setState
      error: error

  _getBuckets: ->
    buckets = bucketsStore.getAll()
    buckets.filter( (bucket) ->
      bucket.get('stage') != 'sys').map( (value,key) ->
      return key)

  _handleConfirm: ->
    actionCreators.saveOutputBucket(@props.configId, @state.outputBucket).then  =>
      @props.onRequestHide()
