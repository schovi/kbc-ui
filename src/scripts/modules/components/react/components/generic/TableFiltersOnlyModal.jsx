import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import DaysFilterInput from './DaysFilterInput';
import DataFilterRow from './DataFilterRow';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';

export default React.createClass({
  propTypes: {
    show: PropTypes.bool,
    onOk: PropTypes.func,
    onSetMapping: PropTypes.func,
    onResetAndHide: PropTypes.func,
    value: PropTypes.object.isRequired,
    allTables: PropTypes.object
  },

  getInitialState() {
    return {
      mapping: this.props.value
    };
  },

  componentWillReceiveProps(nextProps) {
    this.setState({mapping: nextProps.value});
  },

  render() {
    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onResetAndHide}
        bsSize="large"
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Table Data Filter
          </Modal.Title>
        </Modal.Header>

        <Modal.Body>
          <div className="className: 'form-horizontal clearfix">
            <DaysFilterInput
              mapping={this.props.value}
              disabled={false}
              onChange={this.onChangeMapping}
            />
            <DataFilterRow
              value={this.props.value}
              allTables={this.props.allTables}
              disabled={false}
              onChange={this.onChangeMapping}
            />
          </div>
        </Modal.Body>

        <Modal.Footer>
          <ConfirmButtons
            saveStyle="primary"
            saveLabel="Set"
            onSave={this.handleSave}
            onCancel={this.props.onResetAndHide}
            />
        </Modal.Footer>
      </Modal>
    );
  },

  handleSave() {
    this.props.onOk();
  },

  onChangeMapping(newMapping) {
    this.props.onSetMapping(newMapping);
  }


});
