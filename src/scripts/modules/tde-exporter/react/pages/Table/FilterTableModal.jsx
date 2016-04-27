import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import DaysFilterInput from '../../../../components/react/components/generic/DaysFilterInput';
import DataFilterRow from '../../../../components/react/components/generic/DataFilterRow';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';

export default React.createClass({
  propTypes: {
    show: PropTypes.bool,
    onHide: PropTypes.func,
    onSetMapping: PropTypes.func,
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
        onHide={this.props.onHide}
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
              mapping={this.state.mapping}
              disabled={false}
              onChange={this.onChangeMapping}
            />
            <DataFilterRow
              value={this.state.mapping}
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
            onCancel={this.props.onHide}
            />
        </Modal.Footer>
      </Modal>
    );
  },

  onChangeMapping(newMapping) {
    this.setState({mapping: newMapping});
  },

  handleSave() {
    this.props.onSetMapping(this.state.mapping);
    this.clearState();
  }


});
