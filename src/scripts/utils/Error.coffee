
HttpError = require './HttpError'

###
  Error object used for presentation in error page
###
class Error

  constructor: (@title, @text, @data, @exceptionId) ->
    @id = null
    @isUserError = false

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
  else if error.timeout
    error = new Error('Request timeout', error.message)
    error.isUserError = true
    error.id = 'connectTimeout'
    error
  else if error.crossDomain
    error = new Error('Not connected to internet', 'Please try again later.')
    error.id = 'couldNotConnect'
    error.isUserError = true
    error
  else if error.isOperational # error from bluebird
    new Error('Connection error', error.message)
  else
    new Error('Application error', 'Please try reload the browser')

createFromXhrError = (httpError) ->
  title = 'Error'

  text = ''
  if httpError.response.body?.error && httpError.response.body.error != 'User error'
    text += httpError.response.body.error

  if httpError.response.body?.message
    text += httpError.response.body.message

  if !text
    text = 'Application error. Please try reload the browser'

  error = new Error(title, text, httpError, httpError.response.body?.exceptionId)

  if httpError.response.status in [400, 401, 403, 404]
    error.isUserError = true

  error

module.exports =
  Error: Error
  create: createFromException