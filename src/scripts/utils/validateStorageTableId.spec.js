var assert = require('assert');
var validateStorageTableId = require('./validateStorageTableId');


describe('validateStorageTableId', function() {
  describe('#validateStorageTableId()', function() {
    it('should return false on empty string', function() {
      assert.equal(false, validateStorageTableId(''));
    });
    it('should return false on sys bucket', function() {
      assert.equal(false, validateStorageTableId('sys.c-whatever.table'));
    });
    it('should return false on missing table part', function() {
      assert.equal(false, validateStorageTableId('in.c-data.'));
    });
    it('should return false on invalid character in table part', function() {
      assert.equal(false, validateStorageTableId('in.c-data.#'));
    });
    it('should return false on invalid prefix', function() {
      assert.equal(false, validateStorageTableId('in.x-data.abc'));
    });
    it('should return true on valid in bucket table', function() {
      assert.equal(true, validateStorageTableId('in.c-data.abc'));
    });
    it('should return true on valid out bucket table', function() {
      assert.equal(true, validateStorageTableId('out.c-data.abc'));
    });
  });
});
