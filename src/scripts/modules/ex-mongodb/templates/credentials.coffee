# define as [labelValue, propName, type = 'text', isProtected = false]

defaultFields = [
  ['Host Name', 'host', 'text', false]
  ['Port', 'port', 'number', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
  ['Database', 'database', 'text', false]
]

getFields = (componentId) ->
  return defaultFields

module.exports =
  getFields: getFields

  # returns @array of properties that needs to be hashed
  # should return only password property in most cases
  getProtectedProperties: (componentId) ->
    result = []
    fields = getFields(componentId)
    for f in fields
      isProtected = f[3]
      propName = f[1]
      if isProtected
        result.push(propName)
    return result
