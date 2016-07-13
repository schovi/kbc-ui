import React from 'react';
import {Button, Modal} from 'react-bootstrap';
import {diffJson} from 'diff';

function setSignToString(str, sign) {
  if (str[0] === '') {
    return sign + str.substr(1);
  } else {
    return sign + str;
  }
}

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
      let val = part.value;
      let color = '';
      if (part.added)   {
        color = '#cfc';
        val = setSignToString(val, '+');
      }
      if (part.removed) {
        color = '#fcc';
        val = setSignToString(val, '-');
      }
      return (
        <pre style={{'margin-bottom': '1px', 'background-color': color}}>
          {val}
        </pre>);
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
