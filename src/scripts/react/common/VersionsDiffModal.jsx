import React from 'react';
import {Button, Modal} from 'react-bootstrap';
import {/* createPatch,*/ createTwoFilesPatch} from 'diff';
import CodeEditor from './CodeEditor';

/* function setSignToString(str, sign) {
 *   if (str[0] === '') {
 *     return sign + str.substr(1);
 *   } else {
 *     return sign + str;
 *   }
 * }*/

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
          <CodeEditor
            readOnly={true}
            mode="diff"
            value={this.getDiff()}
            lineNumbers={false}
            style={{width: '100%'}}/>
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

  getDiff() {
    if (!this.props.referenceConfigData || !this.props.compareConfigData) {
      return [];
    }
    const referenceData = this.props.referenceConfigData.toJS();
    const compareWithData = this.props.compareConfigData.toJS();

    let from = JSON.stringify(compareWithData, null, '  ');
    let to = JSON.stringify(referenceData, null, '  ');

    from = from + '\n';
    to = to + '\n';

    // return createPatch('config.json', from, to);

    return createTwoFilesPatch('from', 'to', from, to, 'head', 'hedto', {context: 1000});
  }
});
