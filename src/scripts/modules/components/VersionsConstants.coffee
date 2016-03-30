keyMirror = require('react/lib/keyMirror')

module.exports =
  ActionTypes: keyMirror(
    VERSIONS_LOAD_START: null,
    VERSIONS_LOAD_SUCCESS: null,
    VERSIONS_LOAD_ERROR: null,

    VERSIONS_ROLLBACK_START: null,
    VERSIONS_ROLLBACK_SUCCESS: null,
    VERSIONS_ROLLBACK_ERROR: null,

    VERSIONS_COPY_START: null,
    VERSIONS_COPY_SUCCESS: null,
    VERSIONS_COPY_ERROR: null,

    VERSIONS_NEW_NAME_CHANGE: null

  )
