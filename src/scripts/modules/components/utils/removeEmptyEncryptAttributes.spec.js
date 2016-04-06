var assert = require('assert');
var removeEmptyEncryptAttributes = require('./removeEmptyEncryptAttributes');

describe('removeEmptyEncryptAttributes', function() {
  describe('#removeEmptyEncryptAttributes()', function() {
    it('should return scalar when scalar', function() {
      assert.equal('test', removeEmptyEncryptAttributes('test'));
    });

    it('should return object in array', function() {
      assert.deepEqual({'key1': 'val1', '#key2': 'val2'}, removeEmptyEncryptAttributes({'key1': 'val1', '#key2': 'val2'}));
    });

    it('should not return empty string attribute in object', function() {
      assert.deepEqual({'key1': 'val1'}, removeEmptyEncryptAttributes({'key1': 'val1', '#key2': ''}));
    });

    it('should not return null attribute in object', function() {
      assert.deepEqual({'key1': 'val1'}, removeEmptyEncryptAttributes({'key1': 'val1', '#key2': null}));
    });

    it('should return object in array', function() {
      assert.deepEqual([{'key1': 'val1', '#key2': 'val2'}, 'test'], removeEmptyEncryptAttributes([{'key1': 'val1', '#key2': 'val2'}, 'test']));
    });

    it('should not return empty string attribute in object in array', function() {
      assert.deepEqual([{'key1': 'val1'}], removeEmptyEncryptAttributes([{'key1': 'val1', '#key2': ''}]));
    });

    it('should not return empty string attribute in object in array nested', function() {
      assert.deepEqual([[{'key1': 'val1'}]], removeEmptyEncryptAttributes([[{'key1': 'val1', '#key2': ''}]]));
    });

    it('should not return empty string attribute in object in array nested', function() {
      assert.deepEqual({'key1': 'val1', '#key2': [{'#key3': 'val3'}]}, removeEmptyEncryptAttributes({'key1': 'val1', '#key2': [{'#key3': 'val3', '#key4': null}]}));
    });

    it('should not return empty string attribute in object in array nested', function() {
      assert.deepEqual({'key1': 'val1', '#key2': {'#key3': 'val3'}}, removeEmptyEncryptAttributes({'key1': 'val1', '#key2': {'#key3': 'val3', '#key4': null}}));
    });
  });
});
