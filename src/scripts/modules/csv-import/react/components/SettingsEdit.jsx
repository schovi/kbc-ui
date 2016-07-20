import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Input} from 'react-bootstrap';
import Select from '../../../../react/common/Select';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import SapiTableSelector from '../../../components/react/components/SapiTableSelector';
import {List} from 'immutable';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    settings: PropTypes.object.isRequired,
    defaultTable: PropTypes.string.isRequired,
    onChange: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    isSaving: PropTypes.bool.isRequired,
    tables: PropTypes.object.isRequired
  },

  onChangeDestination(value) {
    var settings = this.props.settings.set('destination', value);

    // set primary key if table exists
    if (this.props.tables.has(value)) {
      settings = settings.set('primaryKey', this.props.tables.getIn([value, 'primaryKey']));
    } else {
      settings = settings.set('primaryKey', List());
    }
    this.props.onChange(settings);
  },

  isExistingTable() {
    const destinationTable = this.props.settings.get('destination');
    if (!destinationTable || destinationTable === '') {
      return false;
    }
    return this.props.tables.has(destinationTable);
  },

  onChangeIncremental() {
    var settings = this.props.settings.set('incremental', !this.props.settings.get('incremental', false));
    this.props.onChange(settings);
  },

  onChangePrimaryKey(value) {
    var settings = this.props.settings.set('primaryKey', value);
    this.props.onChange(settings);
  },

  onChangeDelimiter(e) {
    var settings = this.props.settings.set('delimiter', e.target.value);
    this.props.onChange(settings);
  },

  onChangeEnclosure(e) {
    var settings = this.props.settings.set('enclosure', e.target.value);
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
    return (
      <div>
        <h3>CSV Upload Settings</h3>
        <p>
          <div className="text-right">
            <ConfirmButtons
              isSaving={this.props.isSaving}
              onSave={this.props.onSave}
              onCancel={this.props.onCancel}
              placement="right"
              saveLabel="Save Settings"
              />
          </div>
        </p>

        <div className="form-horizontal">
          <div className="row col-md-12">
            <div className="form-group">
              <div className="col-xs-4 control-label">Destination</div>
              <div className="col-xs-8">
                <SapiTableSelector
                  value={this.props.settings.get('destination')}
                  onSelectTableFn={this.onChangeDestination}
                  placeholder="Table in Storage"
                  allowCreate={true}
                />
                <span className="help-block">Table in Storage, where the CSV file will be imported. If the table or bucket does not exist, it will be created. Default <code>{this.props.defaultTable}</code></span>
              </div>
            </div>
          </div>
          <div className="row col-md-12">
            <div className="col-xs-8 col-xs-offset-4">
              <Input
                type="checkbox"
                label="Incremental Load"
                labelClassName="col-xs-12"
                checked={this.props.settings.get('incremental')}
                onChange={this.onChangeIncremental}
                help={(<span>If incremental load is turned on, table will be updated instead of rewritten. Tables with primary key will update rows, tables without primary key will append rows.</span>)}
                />
            </div>
          </div>
          <div className="row col-md-12">
            <div className="form-group">
              <div className="col-xs-4 control-label">Primary Key</div>
              <div className="col-xs-8">
                <Select
                  name="primaryKey"
                  value={this.props.settings.get('primaryKey')}
                  multi={true}
                  allowCreate={true}
                  delimiter=","
                  placeholder="Add a column"
                  emptyStrings={false}
                  onChange={this.onChangePrimaryKey}
                  disabled={this.isExistingTable()}
                />
                <div className="help-block">Primary key of the table. If primary key is set, updates can be done on table by selecting <strong>incremental loads</strong>. Primary key can be compound.</div>
              </div>
            </div>
          </div>
          <div className="row col-md-12">
            <Input
              type="text"
              label="Delimiter"
              labelClassName="col-xs-4"
              wrapperClassName="col-xs-8"
              value={this.props.settings.get('delimiter', ',')}
              onChange={this.onChangeDelimiter}
              help={(<span>Field delimiter used in CSV file. Default value is <code>,</code>. Use <code>\t</code> for tabulator.</span>)}
              standalone={true}
              />
          </div>
          <div className="row col-md-12">
            <Input
              type="text"
              label="Enclosure"
              labelClassName="col-xs-4"
              wrapperClassName="col-xs-8"
              value={this.props.settings.get('enclosure', '"')}
              onChange={this.onChangeEnclosure}
              help={(<span>Field enclosure used in CSV file. Default value is <code>"</code>.</span>)}
              />
          </div>
        </div>
      </div>
    );
  }
});
