module.exports = function(configuration, tables) {
  var inputMappings = [];

  // include items
  configuration.include.forEach(function(tableOrBucket) {
    tables.forEach(function(table) {
      if (table.id === tableOrBucket || table.bucket.id === tableOrBucket) {
        var newInputMapping = {
          source: table.id
        };
        if (configuration.rows > 0) {
          newInputMapping.rows = configuration.rows;
        }
        if (inputMappings.filter(function(inputMapping) {
          return inputMapping.source === table.id;
        }).length === 0) {
          inputMappings.push(newInputMapping);
        }
      }
    });
  });

  // exclude items
  configuration.exclude.forEach(function(tableOrBucket) {
    inputMappings = inputMappings.filter(function(inputMapping) {
      const source = inputMapping.source;
      const bucketStub = source.substr(0, source.lastIndexOf('.'));
      return source !== tableOrBucket && bucketStub !== tableOrBucket;
    });
  });

  return {
    input: {
      tables: inputMappings
    },
    preserve: configuration.preserve
  };
};
