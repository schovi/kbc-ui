React = require 'react'

{button, span} = React.DOM

Link = React.createFactory(require('react-router').Link)


createNewComponentButton = (text, to) ->

  NewComponentButton = React.createClass
    displayName: 'NewComponentButton'

    render: ->
      Link to: to, className: 'btn btn-success',
        span className: 'kbc-icon-plus',
          text


module.exports = createNewComponentButton
