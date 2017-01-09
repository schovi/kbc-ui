var assert = require('assert');
// var Immutable = require('immutable');
var sandboxConfiguration = require('./sandboxConfiguration');

/**
 *
     preserve: false
     backend: @props.backend
     include: []
     rows: 0
 *
 */

const tables = [];

describe('sandboxConfigruration', function() {
  describe('#sandboxConfigruration()', function() {
    it('should propagate one table', function() {
      const configuration = {
        preserve: false,
        backend: 'snowflake',
        include: ['in.c-main.data'],
        exclude: [],
        rows: 0
      };
      const expected = {
        input: {
          tables: [
            {
              source: 'in.c-main.data'
            }
          ]
        },
        preserve: false
      };
      assert.equal(expected, sandboxConfiguration(configuration, tables));
    });

    it('should propagate rows', function() {
      const configuration = {
        preserve: false,
        backend: 'snowflake',
        include: ['in.c-main.data'],
        exclude: [],
        rows: 10
      };
      const expected = {
        input: {
          tables: [
            {
              source: 'in.c-main.data',
              rows: 10

            }
          ]
        },
        preserve: false
      };
      assert.equal(expected, sandboxConfiguration(configuration, tables));
    });

    it('should propagate preserve', function() {
      const configuration = {
        preserve: true,
        backend: 'snowflake',
        include: ['in.c-main.data'],
        exclude: [],
        rows: 0
      };
      const expected = {
        input: {
          tables: [
            {
              source: 'in.c-main.data'

            }
          ]
        },
        preserve: true
      };
      assert.equal(expected, sandboxConfiguration(configuration, tables));
    });

    it('should propagate multiple tables', function() {
      const configuration = {
        preserve: true,
        backend: 'snowflake',
        include: ['in.c-main.data', 'in.c-main.data2'],
        exclude: [],
        rows: 0
      };
      const expected = {
        input: {
          tables: [
            {
              source: 'in.c-main.data'
            },
            {
              source: 'in.c-main.data2'
            }

          ]
        },
        preserve: true
      };
      assert.equal(expected, sandboxConfiguration(configuration, tables));
    });

    it('should drill down a bucket', function() {
      const configuration = {
        preserve: true,
        backend: 'snowflake',
        include: ['in.c-main'],
        exclude: [],
        rows: 0
      };
      const expected = {
        input: {
          tables: [
            {
              source: 'in.c-main.data'
            },
            {
              source: 'in.c-main.data2'
            }

          ]
        },
        preserve: true
      };
      assert.equal(expected, sandboxConfiguration(configuration, tables));
    });


    it('should combine a bucket and table', function() {
      const configuration = {
        preserve: true,
        backend: 'snowflake',
        include: ['in.c-main', 'in.c-main.data'],
        exclude: [],
        rows: 0
      };
      const expected = {
        input: {
          tables: [
            {
              source: 'in.c-main.data'
            },
            {
              source: 'in.c-main.data2'
            }

          ]
        },
        preserve: true
      };
      assert.equal(expected, sandboxConfiguration(configuration, tables));
    });


  });
});
