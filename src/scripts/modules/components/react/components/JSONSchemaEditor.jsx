import React, {PropTypes} from 'react/addons';
import Immutable from 'immutable';

/* global require */
require('./configuration-json.less');
require('json-editor');

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    value: PropTypes.object.isRequired,
    schema: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    readOnly: PropTypes.bool.isRequired,
    disableProperties: PropTypes.bool,
    disableCollapse: PropTypes.bool
  },

  getDefaultProps() {
    return {
      readOnly: false,
      schema: Immutable.Map(),
      disableProperties: false,
      disableCollapse: false
    };
  },

  jsoneditor: null,

  componentWillReceiveProps(nextProps) {
    if (!this.props.schema.equals(nextProps.schema)) {
      this.initJsonEditor();
    }
  },

  initJsonEditor() {
    if (this.jsoneditor) {
      this.jsoneditor.destroy();
    }
    var options =       {
      schema: this.props.schema.toJS(),
      startval: this.props.value.toJS(),
      theme: 'bootstrap3',
      iconlib: 'fontawesome4',
      custom_validators: [],
      ajax: false,
      disable_array_add: false,
      disable_array_delete: false,
      disable_array_delete_last_row: true,
      disable_array_reorder: true,
      disable_collapse: this.props.disableCollapse,
      disable_edit_json: true,
      disable_properties: this.props.disableProperties,
      no_additional_properties: false,
      object_layout: 'normal',
      required_by_default: false,
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
      props.onChange(Immutable.fromJS(json));
    });

    if (this.props.readOnly) {
      jsoneditor.disable();
    }
  },

  componentDidMount() {
    this.initJsonEditor();
  },

  getCurrentValue() {
    return Immutable.fromJS(this.jsoneditor.getValue());
  },

  render() {
    return (
      <form autoComplete="off">
        <div ref="jsoneditor" />
      </form>
    );
  }

});
