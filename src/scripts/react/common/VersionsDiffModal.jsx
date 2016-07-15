import React from 'react';
import {Button, Modal} from 'react-bootstrap';
import {diffJson} from 'diff';
import DetailedDiff from './VersionsDiffModalComponents/DetailedDiff';

function setSignToString(str, sign) {
  if (str[0] === '') {
    return sign + str.substr(1);
  } else {
    return sign + str;
  }
}

function preparseDiffParts(parts) {
  let previousPart = null;
  let result = [];
  for (let part of parts) {
    const isChanged = part.added || part.removed;
    if (!isChanged) {
      if (previousPart) result.push(previousPart);
      previousPart = null;
      result.push(part);
      // if part is added or removed
    } else if (previousPart) {
      const multiPart = {
        isMulti: true,
        first: previousPart,
        second: part
      };
      previousPart = null;
      result.push(multiPart);
    } else {
      previousPart = part;
    }
  }
  return result;
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
      <Modal bsSize="large" show={this.props.show} onHide={this.props.onClose}>
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
    console.log('DATA DIFF', dataDiff);
    const preparsedParts = preparseDiffParts(dataDiff);
    const parts = preparsedParts.map((part) => {
      if (part.isMulti) return this.renderMultiDiff(part.first, part.second);
      return this.renderSimplePreDiff(part);
    });
    return (
      <div>
        {parts}
      </div>
    );
  },

  renderMultiDiff(firstPart, secondPart) {
    const middlePart = (
      <DetailedDiff
        firstPart={firstPart}
        secondPart={secondPart}/>);

    return [
      this.renderSimplePreDiff(firstPart),
      middlePart,
      this.renderSimplePreDiff(secondPart)];
  },

  renderSimplePreDiff(part) {
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
