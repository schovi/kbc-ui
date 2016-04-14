import React, {PropTypes} from 'react';
import Select from '../../../../../react/common/Select';
import {Input} from 'react-bootstrap';
import _ from 'underscore';

export default React.createClass({
  propTypes: {
    value: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    disabled: PropTypes.bool,
    allTables: PropTypes.object.isRequired
  },

  render() {
    return (
      <div className="row col-md-12">
        <div className="form-group form-group-sm">
          <label className="col-xs-2 control-label">Data filter</label>
          <div className="col-xs-4">
            <Select
              name="where_column"
              value={this.props.value.get('where_column')}
              disabled={this.props.disabled || !this.props.value.get('source')}
              placeholder="Select column"
              onChange={this._handleChangeWhereColumn}
              options={this._getColumnsOptions()} />
          </div>
          <div className="col-xs-2">
            <Input
              type="select"
              name="where_operator"
              value={this.props.value.get('where_operator')}
              disabled={this.props.disabled}
              onChange={this._handleChangeWhereOperator}>
              <option value="eq">= (IN)</option>
              <option value="ne">!= (NOT IN)</option>
            </Input>
          </div>
          <div className="col-xs-4">
            <Select
              name="whereValues"
              value={this.props.value.get('where_values')}
              multi={true}
              disabled={this.props.disabled}
              allowCreate={true}
              delimiter=","
              placeholder="Add a value..."
              emptyStrings={true}
              onChange={this._handleChangeWhereValues} />
          </div>
        </div>
      </div>
    );
  },

  _getColumns() {
    if (!this.props.value.get('source')) {
      return [];
    }
    const props = this.props;
    const table = this.props.allTables.find((t) => t.get('id') === props.value.get('source'));
    return table.get('columns').toJS();
  },

  _getColumnsOptions() {
    const columns = this._getColumns();

    return _.map(
      columns, (column) => {
        return {
          label: column,
          value: column
        };
      }
    );
  },

  _handleChangeWhereValues(newValue) {
    const value = this.props.value.set('where_values', newValue);
    this.props.onChange(value);
  },

  _handleChangeWhereOperator(e) {
    const value = this.props.value.set('where_operator', e.target.value);
    this.props.onChange(value);
  },

  _handleChangeWhereColumn(string) {
    const value = this.props.value.set('where_column', string);
    this.props.onChange(value);
  }
});
