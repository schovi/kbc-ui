import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Sticky from 'react-sticky';
import JSONSchemaEditor from './JSONSchemaEditor';

/* global require */
require('./configuration-json.less');

export default React.createClass({
  propTypes: {
    data: PropTypes.string.isRequired,
    isSaving: PropTypes.bool.isRequired,
    isValid: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  schema: {
    'definitions': {
      'attr': {
        'additionalProperties': false,
        'properties': {
          'attr': {
            'type': 'string'
          }
        },
        'title': 'Attribute',
        'type': 'object'
      },
      'childJob': {
        'allOf': [
          {
            '$ref': '#/definitions/job'
          },
          {
            'properties': {
              'placeholders': {
                'format': 'table',
                'title': 'Placeholders',
                'type': 'object'
              },
              'recursionFilter': {
                'description': 'Can contain a value consisting of a name of a field from the parent\'s response, logical operator and a value to compare against. Supported operators are \'==\', \'<\', \'>\', \'<=\', \'>=\', \'!=\'',
                'title': 'Recursion Filter',
                'type': 'string'
              }
            }
          }
        ]
      },
      'fn_base64_encode': {
        'description': 'Encodes data with MIME base64',
        'properties': {
          'args': {
            'additionalItems': false,
            'items': [
              {
                '$ref': '#/definitions/param'
              }
            ],
            'maxItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'base64_encode',
            'type': 'string'
          }
        },
        'title': 'Base64_encode',
        'type': 'object'
      },
      'fn_concat': {
        'properties': {
          'args': {
            'additionalItems': false,
            'items': {
              '$ref': '#/definitions/param'
            },
            'minItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'concat',
            'type': 'string'
          }
        },
        'title': 'Concatenate',
        'type': 'object'
      },
      'fn_date': {
        'description': 'Return date in a specified format',
        'properties': {
          'args': {
            'additionalItems': false,
            'items': [
              {
                'title': 'Date format',
                'type': 'string'
              },
              {
                '$ref': '#/definitions/param',
                'title': 'Time value'
              }
            ],
            'maxItems': 2,
            'minItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'date',
            'type': 'string'
          }
        },
        'title': 'Date',
        'type': 'object'
      },
      'fn_hash_hmac': {
        'description': 'Generate a keyed hash value using the HMAC method',
        'properties': {
          'args': {
            'additionalItems': false,
            'items': [
              {
                'title': 'Hashing algorithm',
                'type': 'string'
              },
              {
                '$ref': '#/definitions/param',
                'title': 'Data'
              },
              {
                'description': 'Shared secret key used for generating the HMAC variant of the message digest.',
                'title': 'Shared secret key',
                'type': 'string'
              },
              {
                'title': 'Raw',
                'type': 'boolean'
              }
            ],
            'minItems': 3,
            'type': 'array'
          },
          'function': {
            'template': 'hash_hmac',
            'type': 'string'
          }
        },
        'title': 'hash_hmac',
        'type': 'object'
      },
      'fn_implode': {
        'properties': {
          'args': {
            'additionalItems': {
              '$ref': '#/definitions/param',
              'title': 'Data'
            },
            'items': [
              {
                'title': 'Glue',
                'type': 'string'
              }
            ],
            'minItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'implode',
            'type': 'string'
          }
        },
        'title': 'Implode',
        'type': 'object'
      },
      'fn_md5': {
        'description': 'Create a MD5 hash of the parameter value',
        'properties': {
          'args': {
            'additionalItems': false,
            'items': [
              {
                '$ref': '#/definitions/param'
              }
            ],
            'maxItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'md5',
            'type': 'string'
          }
        },
        'title': 'MD5',
        'type': 'object'
      },
      'fn_sha1': {
        'description': 'Create a SHA1 hash of the parameter value',
        'properties': {
          'args': {
            'additionalItems': false,
            'items': [
              {
                '$ref': '#/definitions/param'
              }
            ],
            'maxItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'sha1',
            'type': 'string'
          }
        },
        'title': 'SHA1',
        'type': 'object'
      },
      'fn_sprintf': {
        'properties': {
          'args': {
            'additionalItems': {
              '$ref': '#/definitions/param',
              'title': 'Data'
            },
            'items': [
              {
                'title': 'Format',
                'type': 'string'
              }
            ],
            'minItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'hash_hmac',
            'type': 'string'
          }
        },
        'title': 'Sprintf',
        'type': 'object'
      },
      'fn_strtotime': {
        'description': 'Convert a date string to number of seconds from the beginning of the unix epoch',
        'properties': {
          'args': {
            'additionalItems': false,
            'items': [
              {
                '$ref': '#/definitions/param',
                'description': 'e.g.: \'-3 days\'',
                'title': 'Time string'
              },
              {
                '$ref': '#/definitions/param',
                'title': 'Timestamp - base for relative dated. \'now\' by default'
              }
            ],
            'maxItems': 2,
            'minItems': 1,
            'type': 'array'
          },
          'function': {
            'template': 'strtotime',
            'type': 'string'
          }
        },
        'title': 'Strtotime',
        'type': 'object'
      },
      'fn_time': {
        'description': 'Return time from the beginning of the unix epoch in seconds (1.1.1970)',
        'properties': {
          'function': {
            'template': 'time',
            'type': 'string'
          }
        },
        'title': 'Time',
        'type': 'object'
      },
      'function': {
        'additionalProperties': false,
        'oneOf': [
          {
            '$ref': '#/definitions/fn_md5'
          },
          {
            '$ref': '#/definitions/fn_sha1'
          },
          {
            '$ref': '#/definitions/fn_time'
          },
          {
            '$ref': '#/definitions/fn_date'
          },
          {
            '$ref': '#/definitions/fn_strtotime'
          },
          {
            '$ref': '#/definitions/fn_base64_encode'
          },
          {
            '$ref': '#/definitions/fn_hash_hmac'
          },
          {
            '$ref': '#/definitions/fn_sprintf'
          },
          {
            '$ref': '#/definitions/fn_concat'
          },
          {
            '$ref': '#/definitions/fn_implode'
          }
        ],
        'title': 'Function'
      },
      'job': {
        'headerTemplate': '{{ i1 }}: {{self.endpoint}}',
        'properties': {
          'children': {
            'items': {
              '$ref': '#/definitions/job'
            },
            'title': 'Child Jobs',
            'type': 'array',
            'uniqueItems': true
          },
          'dataField': {
            'description': 'Allows to override which field of the response will be exported',
            'title': 'Data field',
            'type': 'string'
          },
          'dataType': {
            'description': 'Name the destination table and data type of results',
            'title': 'Data type',
            'type': 'string'
          },
          'endpoint': {
            'minLength': 1,
            'type': 'string'
          },
          'method': {
            'enum': [
              'GET',
              'POST',
              'FORM'
            ],
            'type': 'string'
          },
          'params': {
            'additionalProperties': {
              '$ref': '#/definitions/param'
            },
            'format': 'table',
            'title': 'Query parameters',
            'type': 'object'
          }
        },
        'title': 'Job',
        'type': 'object'
      },
      'param': {
        'oneOf': [
          {
            'title': 'String',
            'type': 'string'
          },
          {
            '$ref': '#/definitions/function',
            'title': 'Function'
          },
          {
            '$ref': '#/definitions/attr',
            'title': 'Config attribute'
          },
          {
            '$ref': '#/definitions/time',
            'title': 'Time value'
          }
        ]
      },
      'time': {
        'additionalProperties': false,
        'properties': {
          'time': {
            'enum': [
              'previousStart',
              'currentStart'
            ],
            'required': true,
            'type': 'string'
          }
        },
        'title': 'Time value',
        'type': 'object'
      }
    },
    'properties': {
      'debug': {
        'default': false,
        'description': 'Print out all requests to API',
        'title': 'Debug mode',
        'type': 'boolean'
      },
      'incrementalOutput': {
        'default': false,
        'description': 'Set results to be stored incrementally',
        'title': 'Incremental Output',
        'type': 'boolean'
      },
      'jobs': {
        'items': {
          '$ref': '#/definitions/job'
        },
        'title': 'Jobs',
        'type': 'array',
        'uniqueItems': true
      },
      'outputBucket': {
        'default': false,
        'description': 'Output bucket for results',
        'minLength': 4,
        'title': 'Output SAPI bucket',
        'type': 'string'
      }
    },
    'title': 'Config',
    'type': 'object'
  },

  render() {
    return (
      <div className="kbc-configuration-json-edit">
        <div>
          <div className="edit kbc-configuration-editor">
            <Sticky stickyClass="kbc-sticky-buttons-active" className="kbc-sticky-buttons" topOffset={-60} stickyStyle={{}}>
              <ConfirmButtons
                isSaving={this.props.isSaving}
                onSave={this.props.onSave}
                onCancel={this.props.onCancel}
                placement="right"
                saveLabel="Save configuration"
                isDisabled={!this.props.isValid}
                />
            </Sticky>
            <JSONSchemaEditor
              schema={this.schema}
              value={this.props.data}
              onChange={this.handleChange}
              readOnly={this.props.isSaving}
            />
          </div>
        </div>
      </div>
    );
  },

  handleChange(value) {
    this.props.onChange(value);
  }
});
