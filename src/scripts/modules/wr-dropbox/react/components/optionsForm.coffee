React = require('react')
Input = React.createFactory(require('react-bootstrap').Input)
{div} = React.DOM

module.exports = React.createClass
  displayName: 'optionsForm'

  propTypes:
    parameters: React.PropTypes.object.isRequired
    onChangeParameterFn: React.PropTypes.func.isRequired

  render: ->
    div className: 'form-horizontal',
      div className: 'row',
        div className: 'col-md-8',
          Input
            type: 'checkbox'
            label: 'Rewrite files if exists in destination dropbox'
            checked: @_rewriteEndabled()
            wrapperClassName: 'col-xs-12'
            labelClassName: 'col-xs-12'
            onChange: (event) =>
              value = false
              if event.target.checked
                value = 'rewrite'
              @props.onChangeParameterFn('mode', value)


  _rewriteEndabled: ->
    rewrite = @props.parameters.get('mode', null)
    rewrite == 'rewrite'
