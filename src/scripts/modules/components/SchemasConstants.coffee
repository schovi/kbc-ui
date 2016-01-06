keyMirror = require('keyMirror')

module.exports =
  ActionTypes: keyMirror(
    SCHEMA_LOAD_START: null,
    SCHEMA_LOAD_SUCCESS: null,
    SCHEMA_LOAD_ERROR: null
  )
