keyMirror = require('react/lib/keyMirror')

module.exports =
  ActionTypes: keyMirror(
    CREDENTIALS_LOAD: null
    CREDENTIALS_LOAD_SUCCESS: null
    CREDENTIALS_LOAD_ERROR: null

    CREDENTIALS_CREATE: null
    CREDENTIALS_CREATE_SUCCESS: null
    CREDENTIALS_CREATE_ERROR: null

    CREDENTIALS_DROP: null
    CREDENTIALS_DROP_SUCCESS: null
    CREDENTIALS_DROP_ERROR: null
  )
