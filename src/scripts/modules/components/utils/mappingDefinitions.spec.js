var assert = require('assert');
var mappingDefinitions = require('./mappingDefinitions');
var Immutable = require('immutable');

const inputMappingDefinition =  Immutable.fromJS({
  'label': 'Load data from table',
  'destination': 'data.csv'
});
const inputMappingDefinitions = Immutable.List([inputMappingDefinition]);

const outputMappingDefinition = Immutable.fromJS({
  'label': 'Store downloaded CSV',
  'source': 'data.csv'
});
const outputMappingDefinitions = Immutable.List([outputMappingDefinition]);

describe('mappingDefinitions', function() {
  describe('#findInputMappingDefinition()', function() {
    it('should return the definition when present', function() {
      var value = Immutable.fromJS({
        destination: 'data.csv'
      });
      assert.deepEqual(inputMappingDefinition.toJS(), mappingDefinitions.findInputMappingDefinition(inputMappingDefinitions, value).toJS());
    });
    it('should return empty map when not present', function() {
      var value = Immutable.fromJS({
        destination: 'notfound.csv'
      });
      assert.deepEqual({}, mappingDefinitions.findInputMappingDefinition(inputMappingDefinitions, value).toJS());
    });
  });

  describe('#findOutputMappingDefinition()', function() {
    it('should return the definition when present', function() {
      var value = Immutable.fromJS({
        source: 'data.csv'
      });
      assert.deepEqual(outputMappingDefinition.toJS(), mappingDefinitions.findOutputMappingDefinition(outputMappingDefinitions, value).toJS());
    });
    it('should return empty map when not present', function() {
      var value = Immutable.fromJS({
        source: 'notfound.csv'
      });
      assert.deepEqual({}, mappingDefinitions.findOutputMappingDefinition(outputMappingDefinitions, value).toJS());
    });
  });

  describe('#getInputMappingValue()', function() {
    it('should add input mapping to an empty value', function() {
      const value = Immutable.fromJS([]);
      const expected = [
        {
          'source': '',
          'destination': 'data.csv'
        }
      ];
      assert.deepEqual(expected, mappingDefinitions.getInputMappingValue(inputMappingDefinitions, value).toJS());
    });
    it('should add input mapping to an existing value', function() {
      const value = Immutable.fromJS(
        [
          {
            'source': 'in.c-main.mydata',
            'destination': 'mydata.csv'
          }
        ]
      );
      const expected = [
        {
          'source': 'in.c-main.mydata',
          'destination': 'mydata.csv'
        },
        {
          'source': '',
          'destination': 'data.csv'
        }
      ];
      assert.deepEqual(expected, mappingDefinitions.getInputMappingValue(inputMappingDefinitions, value).toJS());
    });
    it('should not overwrite existing input mapping', function() {
      const value = Immutable.fromJS(
        [
          {
            'source': 'in.c-main.mydata',
            'destination': 'mydata.csv'
          },
          {
            'source': 'in.c-main.data',
            'destination': 'data.csv'
          }
        ]
      );
      const expected = [
        {
          'source': 'in.c-main.mydata',
          'destination': 'mydata.csv'
        },
        {
          'source': 'in.c-main.data',
          'destination': 'data.csv'
        }
      ];
      assert.deepEqual(expected, mappingDefinitions.getInputMappingValue(inputMappingDefinitions, value).toJS());
    });
  });


  describe('#getOutputMappingValue()', function() {
    it('should add output mapping to an empty value', function() {
      const value = Immutable.fromJS([]);
      const expected = [
        {
          'source': 'data.csv',
          'destination': ''
        }
      ];
      assert.deepEqual(expected, mappingDefinitions.getOutputMappingValue(outputMappingDefinitions, value).toJS());
    });
    it('should add out mapping to an existing value', function() {
      const value = Immutable.fromJS(
        [
          {
            'source': 'mydata.csv',
            'destination': 'out.c-main.mydata'
          }
        ]
      );
      const expected = [
        {
          'source': 'mydata.csv',
          'destination': 'out.c-main.mydata'
        },
        {
          'source': 'data.csv',
          'destination': ''
        }
      ];
      assert.deepEqual(expected, mappingDefinitions.getOutputMappingValue(outputMappingDefinitions, value).toJS());
    });
    it('should not overwrite existing output mapping', function() {
      const value = Immutable.fromJS(
        [
          {
            'source': 'mydata.csv',
            'destination': 'out.c-main.mydata'
          },
          {
            'source': 'data.csv',
            'destination': 'out.c-main.data'
          }
        ]
      );
      const expected = [
        {
          'source': 'mydata.csv',
          'destination': 'out.c-main.mydata'
        },
        {
          'source': 'data.csv',
          'destination': 'out.c-main.data'
        }
      ];
      assert.deepEqual(expected, mappingDefinitions.getOutputMappingValue(outputMappingDefinitions, value).toJS());
    });
  });
});
