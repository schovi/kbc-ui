var isObject = function(val) {
  if (val === null) { return false;}
  return ( (typeof val === 'function') || (typeof val === 'object') );
};

var preferEncryptedAttributesFromObject = function(data) {
  var keys = Object.keys(data);
  keys.forEach(function(key) {
    if (key.substr(0, 1) === '#') {
      var plainKey = key.substr(1);
      if (data[key] !== '' && data[key] !== null) {
        // try to delete plain value if encrypted value is not empty/null
        if (data[plainKey]) {
          delete data[plainKey];
        }
      } else {
        // try to replace empty/null encrypted value by plain value if exists
        if (data[plainKey]) {
          data[key] = data[plainKey];
          delete data[plainKey];
        }
      }
    } else {
      var encKey = '#' + key;
      // delete plain value if encrypted exists and is not empty/null
      if (data[encKey] && data[encKey] !== null && data[encKey] !== '') {
        delete data[key];
      }
    }
    if (isObject(data[key])) {
      preferEncryptedAttributesFromObject(data[key]);
    } else if (Array.isArray(data[key])) {
      preferEncryptedAttributesFromArray(data[key]);
    }
  });
};

var preferEncryptedAttributesFromArray = function(data) {
  data.forEach(function(item) {
    if (isObject(item)) {
      preferEncryptedAttributesFromObject(item);
    }
    if (Array.isArray(item)) {
      preferEncryptedAttributesFromArray(item);
    }
  });
};

module.exports = function(configuration) {
  if (isObject(configuration)) {
    preferEncryptedAttributesFromObject(configuration);
  } else if (Array.isArray(configuration)) {
    preferEncryptedAttributesFromArray(configuration);
  }
  return configuration;
};
