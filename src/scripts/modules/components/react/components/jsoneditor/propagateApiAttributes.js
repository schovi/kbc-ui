import Immutable from 'immutable';

// find all attrs
var iterate = function(obj) {
  var params = [];
  var keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) {
    if (typeof obj[keys[i]] === 'object' && obj[keys[i]] !== null) {
      var newParams = iterate(obj[keys[i]]);
      for (var j = 0; j < newParams.length; j++) {
        params.push(newParams[j]);
      }
    }
    if (keys[i] === 'attr' && typeof obj[keys[i]] === 'string') {
      params.push(obj[keys[i]]);
    }
  }
  return params;
};

export default function(apiValue, paramsSchema) {
  var params = iterate(apiValue);
  // add all items from requiredHeaders
  if (apiValue && apiValue.http && apiValue.http.requiredHeaders) {
    for (var i = 0; i < apiValue.http.requiredHeaders.length; i++) {
      params.push(apiValue.http.requiredHeaders[i]);
    }
  }
  // inject new properties into params schema
  var newProperties = {};
  for (var j = 0; j < params.length; j++) {
    newProperties[params[j]] = {
      'type': 'string',
      'default': false,
      'description': 'Required by API configuration',
      'title': params[j]
    };
  }
  var result;
  if (!paramsSchema.has('properties')) {
    result = paramsSchema.setIn(['properties'], Immutable.fromJS(newProperties));
  } else {
    result = paramsSchema.mergeDeepIn(['properties'], Immutable.fromJS(newProperties));
  }
  // try to make them default, but does not somehow work
  var newDefaultProperties = [];
  for (var l = 0; l < params.length; l++) {
    newDefaultProperties.push(params[i]);
  }
  if (!result.has('defaultProperties')) {
    result = result.setIn(['defaultProperties'], Immutable.fromJS(newDefaultProperties));
  } else {
    result = result.mergeDeepIn(['defaultProperties'], Immutable.fromJS(newDefaultProperties));
  }
  return result;
}
