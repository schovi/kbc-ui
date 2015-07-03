React = require('react')
OptionsForm = require '../../components/optionsForm'
Immutable = require 'immutable'
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
Button = React.createFactory(require('react-bootstrap').Button)
Modal = React.createFactory(require('react-bootstrap').Modal)
Input = React.createFactory(require('react-bootstrap').Input)
OptionsForm = React.createFactory OptionsForm
Loader = React.createFactory(require('kbc-react-components').Loader)

{i, span, div, p, strong, form, input, label, div} = React.DOM


module.exports = React.createClass
  displayName: 'optionsModal'

  propTypes:
    parameters: React.PropTypes.object
    updateParamsFn: React.PropTypes.func
    isUpadting: React.PropTypes.bool

  getInitialState: ->
    parameters: @props.parameters

  ComponentWillReceiveProps: (newProps) ->
    @setState
      parameters: newProps.parameters


  render: ->
    Modal
      title: 'Options'
      onRequestHide: @props.onRequestHide
    ,
      div className: 'modal-body',
        OptionsForm
          parameters: @state.parameters
          onChangeParameterFn: @_handleChangeParam

      div className: 'modal-footer',
        ButtonToolbar null,
          Loader() if @props.isUpadting
          Button
            onClick: @props.onRequestHide
            disabled: @props.isUpadting
            bsStyle: 'link'
          ,
            'Cancel'
          Button
            onClick: @_handleConfirm
            disabled: @props.isUpadting
            bsStyle: 'success'
          ,
            'Save'

  _handleConfirm: ->
    @props.updateParamsFn(@state.parameters).then =>
      @props.onRequestHide()

  _handleChangeParam: (param, value) ->
    newParameters = @state.parameters.set(param, value)
    @setState
      parameters: newParameters
