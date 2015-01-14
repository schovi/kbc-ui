React = require 'react'
_ = require 'underscore'
Input = React.createFactory(require('react-bootstrap').Input)

{form, div, label, p, a, strong} = React.DOM


module.exports = React.createClass
  displayName: 'FixedIP'
  propTypes:
    credentials: React.PropTypes.object.isRequired

  render: ->
    form null,
      div className: 'row',
        div className: 'well',
          'If you need to allow connection on your side, fill your IP address as
          host parameter in database credentials and let us know by '
          a href: 'mailto:support@keboola.com',
            'sending an email to support@keboola.com'
          ' so we can setup connection to your database to be always established
          from '
          strong null, 'syrup-out.keboola.com'
          ' and allow the address on your side. '
          'To get more info read '
          a href: 'http://wiki.keboola.com/home/keboola-connection/ui-articles/fixed-ip',
            'here'
          '.'
