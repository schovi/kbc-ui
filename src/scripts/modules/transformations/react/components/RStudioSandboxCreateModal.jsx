import React from 'react';
// import {Modal, Button, Form, FormGroup, Col, FormControl, ControlLabel, Checkbox} from 'react-bootstrap';
import {Modal, Button, Input} from 'react-bootstrap';
import Immutable from 'immutable';
import Select from 'react-select';

module.exports = React.createClass({
  displayName: 'RStudioSandboxCreateModal',
  propTypes: {
    show: React.PropTypes.bool.isRequired,
    close: React.PropTypes.func.isRequired,
    create: React.PropTypes.func.isRequired,
    tables: React.PropTypes.object.isRequired
  },
  getInitialState() {
    return {
      rows: 0,
      tables: Immutable.List()
    };
  },

  render: function() {
    return (
      <Modal show={this.props.show} onHide={this.props.close} bsSize="large">
        <Modal.Header closeButton>
          <Modal.Title>Create RStudio Sandbox</Modal.Title>
        </Modal.Header>
        <Modal.Body>
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
                  Tables must be loaded into RStudio when creating. Data cannot be added later.
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
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.close} bsStyle="link">Close</Button>
          <Button onClick={this.create} bsStyle="primary">Create</Button>
        </Modal.Footer>
      </Modal>
    );
  },
  create: function() {
    const tablesList = this.state.tables.map(function(table) {
      return table.get('value');
    }).toList();
    this.props.create(tablesList, this.state.rows);
    this.props.close();
  },
  onChangeRows: function(e) {
    this.setState({
      rows: e.target.value
    });
  },
  onChangeTables: function(valueString, valueArray) {
    this.setState({
      tables: Immutable.fromJS(valueArray)
    });
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
  }
});

