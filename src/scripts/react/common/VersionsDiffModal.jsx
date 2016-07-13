import React from 'react';
import {Button, Modal} from 'react-bootstrap';
import {diffJson, createPatch, createTwoFilesPatch} from 'diff';
import CodeEditor from './CodeEditor';

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
      <Modal show={this.props.show} onHide={this.props.onClose} bsSize="large">
        <Modal.Header closeButton>
          <Modal.Title>Versions Diff</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <CodeEditor readOnly={true} mode='diff' value={this.getDiff()} style={{width:'100%'}}>
          </CodeEditor>
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

    var from = JSON.stringify(referenceData, null, '  ');
    var to = JSON.stringify(compareWithData, null, '  ');

    return createPatch('config.json', from, to);

    // return createTwoFilesPatch('config.json', 'config.json', from, to, '', '', {context: 1000});
  }
});
