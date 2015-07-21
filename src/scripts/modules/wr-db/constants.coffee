keyMirror = require('react/lib/keyMirror')

module.exports =
  ActionTypes: keyMirror
    WR_DB_API_ERROR: null
    WR_DB_GET_CREDENTIALS_SUCCESS: null #not used
    WR_DB_GET_TABLES_SUCCESS: null #not used
    WR_DB_GET_CONFIGURATION_SUCCESS: null

    WR_DB_SET_TABLE_START: null
    WR_DB_SET_TABLE_SUCCESS: null
    WR_DB_GET_TABLE_SUCCESS: null

    WR_DB_SAVE_CREDENTIALS_START: null
    WR_DB_SAVE_CREDENTIALS_SUCCESS: null


    WR_DB_SET_EDITING: null

    WR_DB_SAVE_COLUMNS_SUCCESS: null
    WR_DB_SAVE_COLUMNS_START: null

    WR_DB_LOAD_PROVISIONING_START: null
    WR_DB_LOAD_PROVISIONING_SUCCESS: null
