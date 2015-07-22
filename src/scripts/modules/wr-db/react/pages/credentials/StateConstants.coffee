keyMirror = require('react/lib/keyMirror')

module.exports =
  States: keyMirror
    INIT: null
    LOADING_PROV_READ: null
    PREPARING_PROV_WRITE: null
    SHOW_PROV_READ_CREDS: null
    SHOW_STORED_CREDS: null
    CREATE_NEW_CREDS: null
    SAVING_NEW_CREDS: null
