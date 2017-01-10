var assert = require('assert');
var sandboxConfiguration = require('./sandboxConfiguration');

const tables = [
  {
    id: 'in.c-main.data',
    bucket: {
      id: 'in.c-main'
    }
  },
  {
    id: 'in.c-main.data2',
    bucket: {
      id: 'in.c-main'
    }
  },
  {
    id: 'in.c-main2.data',
    bucket: {
      id: 'in.c-main2'
    }
  }
];

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
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data'
          }
        ],
        preserve: '0'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
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
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data',
            rows: 10

          }
        ],
        preserve: '0'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
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
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data'
          }
        ],
        preserve: '1'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
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
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data'
          },
          {
            source: 'in.c-main.data2',
            destination: 'in.c-main.data2'
          }
        ],
        preserve: '1'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
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
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data'
          },
          {
            source: 'in.c-main.data2',
            destination: 'in.c-main.data2'
          }
        ],
        preserve: '1'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
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
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data'
          },
          {
            source: 'in.c-main.data2',
            destination: 'in.c-main.data2'
          }
        ],
        preserve: true
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
    });

    it('should exclude table', function() {
      const configuration = {
        preserve: false,
        backend: 'snowflake',
        include: ['in.c-main'],
        exclude: ['in.c-main.data2'],
        rows: 0
      };
      const expected = {
        input: [
          {
            source: 'in.c-main.data',
            destination: 'in.c-main.data'
          }
        ],
        preserve: '0'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
    });

    it('should exclude bucket', function() {
      const configuration = {
        preserve: false,
        backend: 'snowflake',
        include: ['in.c-main', 'in.c-main.data'],
        exclude: ['in.c-main'],
        rows: 0
      };
      const expected = {
        input: [],
        preserve: '0'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
    });

    it('should not include nonexisting table', function() {
      const configuration = {
        preserve: false,
        backend: 'snowflake',
        include: ['in.c-doesnotexist', 'in.c-doesnotexist.table'],
        exclude: [],
        rows: 0
      };
      const expected = {
        input: [],
        preserve: '0'
      };
      assert.deepEqual(sandboxConfiguration(configuration, tables), expected);
    });
  });
});
