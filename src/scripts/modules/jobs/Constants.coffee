keyMirror = require('react/lib/keyMirror')

module.exports =
  ActionTypes: keyMirror(
    JOBS_LOAD: null
    JOBS_LOAD_SUCCESS: null
    JOBS_LOAD_ERROR: null
    JOBS_SET_QUERY: null
    JOBS_SEARCH: null

    JOB_LOAD: null
    JOB_LOAD_SUCCESS: null
    JOB_LOAD_ERROR: null

    JOB_TERMINATE_START: null
    JOB_TERMINATE_ERROR: null
    JOB_TERMINATE_SUCCESS: null

    JOBS_LATEST_LOAD_START: null
    JOBS_LATEST_LOAD_SUCCESS: null
    JOBS_LATEST_LOAD_ERROR: null

#    :null
  )
