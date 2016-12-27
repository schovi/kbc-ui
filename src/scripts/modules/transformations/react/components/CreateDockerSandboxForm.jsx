import React from 'react';
import {Input} from 'react-bootstrap';
import Immutable from 'immutable';
import Select from 'react-select';

module.exports = React.createClass({
  displayName: 'CreateDockerSandboxForm',
  propTypes: {
    tables: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired,
    type: React.PropTypes.string.isRequired
  },
  getInitialState() {
    return {
      rows: 0,
      tables: Immutable.List()
    };
  },

  render: function() {
    return (
      <form className="form-horizontal">
        <div className="form-group">
          <label className="col-sm-3 control-label">
            Tables
          </label>
          <div className="col-sm-9">
            <Select
              value={this.state.tables.toJS()}
              multi={true}
              options={this.getTablesOptions().toJS()}
              onChange={this.onChangeTables}
              placeholder="Select tables to load..."
            />
            <p className="help-block">
              Tables must be loaded into {this.props.type} when creating. Data cannot be added later.
            </p>
          </div>
        </div>
        <div className="form-group">
          <label className="col-sm-3 control-label">
            Sample rows
          </label>
          <div className="col-sm-9">
            <Input
              type="number"
              placeholder="Number of rows"
              value={this.state.rows}
              onChange={this.onChangeRows}
              help="0 to import all rows"
            />
          </div>
        </div>
      </form>
    );
  },
  onChangeRows: function(e) {
    this.setState({
      rows: parseInt(e.target.value, 10)
    });
    this.onChange();
  },
  onChangeTables: function(valueString, valueArray) {
    this.setState({
      tables: Immutable.fromJS(valueArray)
    });
    this.onChange();
  },
  getTablesOptions: function() {
    return this.props.tables.map(
      function(table) {
        return {
          label: table,
          value: table
        };
      }
    ).sortBy(function(table) {
      return table.value.toLowerCase();
    });
  },
  onChange: function() {
    console.log(this.state);
    const state = this.state;
    const tablesList = this.state.tables.map(function(table) {
      var retVal = {
        source: table.get('value')
      };
      if (state.rows > 0) {
        retVal.limit = state.rows;
      }
      return retVal;
    }).toList();
    this.props.onChange({
      input: {
        tables: tablesList.toJS()
      }
    });
  }
});

