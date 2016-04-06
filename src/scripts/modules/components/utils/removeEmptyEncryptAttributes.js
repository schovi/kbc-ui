var isObject = function(val) {
  if (val === null) { return false;}
  return ( (typeof val === 'function') || (typeof val === 'object') );
};

var removeEmptyEncryptAttributesFromObject = function(data) {
  var keys = Object.keys(data);
  keys.forEach(function(key) {
    if (key.substr(0, 1) === '#' && (data[key] === '' || data[key] === null)) {
      delete data[key];
    } else {
      if (isObject(data[key])) {
        removeEmptyEncryptAttributesFromObject(data[key]);
      }
      if (Array.isArray(data[key])) {
        removeEmptyEncryptAttributesFromArray(data[key]);
      }
    }
  });
};

var removeEmptyEncryptAttributesFromArray = function(data) {
  data.forEach(function(item) {
    if (isObject(item)) {
      removeEmptyEncryptAttributesFromObject(item);
    }
    if (Array.isArray(item)) {
      removeEmptyEncryptAttributesFromArray(item);
    }
  });
};

module.exports = function(configuration) {
  if (isObject(configuration)) {
    removeEmptyEncryptAttributesFromObject(configuration);
  }

  if (Array.isArray(configuration)) {
    removeEmptyEncryptAttributesFromArray(configuration);
  }
  return configuration;
};
