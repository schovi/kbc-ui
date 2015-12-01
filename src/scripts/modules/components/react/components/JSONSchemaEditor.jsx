import React, {PropTypes} from 'react';

/* global require */
require('./configuration-json.less');
require('json-editor');

export default React.createClass({
  propTypes: {
    value: PropTypes.string.isRequired,
    schema: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    readOnly: PropTypes.bool.isRequired
  },

  jsoneditor: null,

  componentDidMount() {
    var options =       {
      schema: this.props.schema,
      startval: JSON.parse(this.props.value),
      theme: 'bootstrap3',
      iconlib: 'fontawesome4',
      custom_validators: []
    };

    // Custom validators must return an array of errors or an empty array if valid
    options.custom_validators.push(function(schema, value, path) {
      var errors = [];
      if (schema.type === 'string' && schema.template) {
        if (schema.template !== value) {
          errors.push({
            path: path,
            property: 'value',
            message: 'Value does not match schema template'
          });
        }
      }
      return errors;
    });

    var jsoneditor = new window.JSONEditor(
      this.refs.jsoneditor.getDOMNode(),
      options
    );
    this.jsoneditor = jsoneditor;
    var props = this.props;

    // When the value of the editor changes, update the JSON output and TODO validation message
    jsoneditor.on('change', function() {
      var json = jsoneditor.getValue();
      props.onChange(JSON.stringify(json));
    });
  },

  componentWillUnmount() {

  },

  render() {
    return (
        <div ref="jsoneditor">
        </div>
    );
  }

});
