


class Error

  constructor: (@title, @text, @data) ->

  @fromXhrError: (error) ->
    if error.status = 404
      title = 'Page not  found'
    else
      title = 'Application error'

    if error.response?.body?.message
      text = error.response?.body?.message
    else
      text = 'Application error. Please try reload the browser'

    return new Error(title, text, error)

  getTitle: ->
    @title

  getText: ->
    @text

  data: ->
    @data


module.exports = Error