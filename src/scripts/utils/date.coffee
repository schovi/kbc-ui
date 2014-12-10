# date utils

moment = require 'moment'

module.exports =

  format: (date, format = 'YYYY-MM-DD hh:mm:ss') ->
    moment(date).format(format)