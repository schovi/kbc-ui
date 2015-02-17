
class HttpError extends Error

  constructor: (@response) ->
    @message = @response.body?.error


module.exports = HttpError