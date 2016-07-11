import React from 'react';
import {Button, Modal} from 'react-bootstrap';
import {diffJson} from 'diff';

export default React.createClass({

  propTypes: {
    version: React.PropTypes.object.isRequired,
    show: React.PropTypes.bool.isRequired,
    onClose: React.PropTypes.func.isRequired,
    referenceConfigData: React.PropTypes.object.isRequired,
    compareConfigData: React.PropTypes.object.isRequired
  },

  render() {
    return (
      <Modal show={this.props.show} onHide={this.props.onClose}>
        <Modal.Header closeButton>
          <Modal.Title>Versions Diff</Modal.Title>
        </Modal.Header>
        <Modal.Body>
           {this.renderDiff()}
        </Modal.Body>
        <Modal.Footer>
          <Button
            bsStyle="link"
            onClick={this.props.onClose}>
            Close
          </Button>
        </Modal.Footer>
      </Modal>
    );
  },

  renderDiff() {
    const dataDiff = this.getDiff();
    const parts = dataDiff.map((part) => {
      let color = 'grey';
      if (part.added)   color = 'green';
      if (part.removed) color = 'red';
      return (
        <span
          style={{'color': color}}
        > {part.value} </span>
      );
    });
    return (
      <div>
        {parts}
      </div>
    );
  },

  getDiff() {
    if (!this.props.referenceConfigData || !this.props.compareConfigData) {
      return [];
    }
    const referenceData = this.props.referenceConfigData.toJS();
    const compareWithData = this.props.compareConfigData.toJS();
    return diffJson(compareWithData, referenceData);
  }
});
