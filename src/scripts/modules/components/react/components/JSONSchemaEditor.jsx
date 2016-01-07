import React, {PropTypes} from 'react';

/* global require */
require('./configuration-json.less');
require('json-editor');

export default React.createClass({
  propTypes: {
    value: PropTypes.object.isRequired,
    schema: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    readOnly: PropTypes.bool.isRequired
  },

  getDefaultProps() {
    return {
      readOnly: false
    };
  },

  jsoneditor: null,

  componentDidMount() {
    var options =       {
      schema: this.props.schema,
      startval: this.props.value,
      theme: 'bootstrap3',
      iconlib: 'fontawesome4',
      custom_validators: [],
      ajax: false,
      disable_array_add: false,
      disable_array_delete: false,
      disable_array_reorder: false,
      disable_collapse: false,
      disable_edit_json: true,
      disable_properties: false,
      no_additional_properties: false,
      object_layout: 'normal',
      required_by_default: true,
      show_errors: 'interaction'
    };

    if (this.props.readOnly) {
      options.disable_array_add = true;
      options.disable_collapse = true;
      options.disable_edit_json = true;
      options.disable_properties = true;
      options.disable_array_delete = true;
    }

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
      props.onChange(json);
    });

    if (this.props.readOnly) {
      jsoneditor.disable();
    }
  },

  componentDidUpdate() {
    this.jsoneditor.setValue(this.props.value);
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