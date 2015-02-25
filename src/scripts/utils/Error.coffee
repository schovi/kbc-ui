
HttpError = require './HttpError'

###
  Error object used for presentation in error page
###
class Error

  constructor: (@title, @text, @data, @exceptionId) ->


  getTitle: ->
    @title

  getText: ->
    @text

  data: ->
    @data

  getExceptionId: ->
    @exceptionId

createFromException = (error) ->
  if error instanceof HttpError
    createFromXhrError error
  else if error.isOperational # error from bluebird
    new Error('Connection error', error.message)
  else
    new Error('Application error', 'Please try reload the browser')

createFromXhrError = (httpError) ->
  title = switch httpError.response.status
    when 404 then 'Page not found'
    when 401 then 'Unauthorized access'
    else 'Application Error'

  if httpError.response.body?.error
    text = httpError.response.body.error
  else if httpError.response.body?.message
    text = httpError.response.body.message
  else
    text = 'Application error. Please try reload the browser'

  new Error(title, text, httpError, httpError.response.body?.exceptionId)

module.exports =
  Error: Error
  create: createFromException