import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Input} from 'react-bootstrap';
import Autosuggest from 'react-autosuggest';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    settings: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    tables: PropTypes.object.isRequired
  },

  onChangeDestination(value) {
    var settings = this.props.settings.set('destination', value);
    this.props.onChange(settings);
  },

  onChangeIncremental(e) {
    var settings = this.props.settings.set('incremental', e.target.value);
    this.props.onChange(settings);
  },

  getDestinationSuggestions() {
    const tables = this.props.tables.map(function(table) {
      return ({
        name: table.get('id')
      });
    });
    return function(value, callback) {
      const inputValue = value.trim().toLowerCase();
      const inputLength = inputValue.length;
      if (inputLength === 0) {
        return callback(null, []);
      }
      var suggestions = tables.filter(function(table) {
        return table.name.toLowerCase().indexOf(inputValue) >= 0;
      }).sortBy(function(table) {
        return table.name;
      }).slice(0, 7).map(function(table) {
        return table.name;
      }).toList().toJS();
      return callback(null, suggestions);
    };
  },

  render() {
    const suggestInputProps = {
      value: this.props.settings.get('destination'),
      onChange: this.onChangeDestination,
      placeholder: 'Destination in Storage',
      className: 'form-control',
      id: 'destination',
      name: 'destination'
    };
    return (
      <div>
        <div className="row col-md-12">
          <div className="form-group">
            <div className="col-xs-4 control-label">Destination</div>
            <div className="col-xs-8">
              <Autosuggest
                suggestions={this.getDestinationSuggestions()}
                inputAttributes={suggestInputProps}
              />
            </div>
          </div>

        </div>
        <div className="row col-md-12">
          <div className="col-xs-8 col-xs-offset-4">
            <Input
              type="checkbox"
              label="Incremental"
              labelClassName="col-xs-4"
              wrapperClassName="col-xs-8"
              value={this.props.settings.get('incremental')}
              onChange={this.onChangeIncremental}
              />
          </div>
        </div>
      </div>
    );
  }
});
