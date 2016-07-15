import React, {PropTypes} from 'react';
import {createTwoFilesPatch} from 'diff';
import CodeEditor from '../CodeEditor';
import _ from 'underscore';

function multiDiffValueToString(value) {
  if (_.isArray(value)) {
    return value.join(',');
  }
  // if (!value) return '';
  return value.toString();
}

function reconstructIncompleteJson(strValue) {
  let result = strValue.trim();
  if (result[0] !== '{') result = '{' + result;
  const lastIdx = () => result.length - 1;
  if (result[lastIdx()] === ',') result = result.substr(0, lastIdx());
  if (result[lastIdx()] !== '}') result = result + '}';
  return JSON.parse(result);
}
function  getMultiPartsDiff(firstValue, secondValue) {
  const firstJson = reconstructIncompleteJson(firstValue);
  const secondJson = reconstructIncompleteJson(secondValue);
  let firstLines = [];
  let secondLines = [];
  for (let key of _.keys(firstJson)) {
    firstLines.push(key);
    firstLines.push(multiDiffValueToString(firstJson[key]));
    secondLines.push(key);
    secondLines.push(multiDiffValueToString(secondJson[key]));
  }
  return createTwoFilesPatch('config.json', 'config.json',
                             firstLines.join('\n') + '\n',
                             secondLines.join('\n') + '\n',
                             '', '', {context: 1000});
}

export default React.createClass({
  propTypes: {
    firstPart: PropTypes.object.isRequired,
    secondPart: PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      showDetails: false
    };
  },

  render() {
    return (
      <div>
        <div className="text-center">
          <button
            className="btn btn-default btn-sm"
            onClick={() => this.setState({showDetails: !this.state.showDetails})}>
            <i className="fa fa-fw fa-arrows-v" />
            {this.state.showDetails ? 'Hide' : 'Compare'}
          </button>
        </div>
        {this.state.showDetails ? this.renderCodeDitorDiff() : null}
      </div>
    );
  },

  renderCodeDitorDiff() {
    const multiDiff = getMultiPartsDiff(this.props.firstPart.value, this.props.secondPart.value);
    return (
      <CodeEditor
        readOnly={true}
        lineNumbers={false}
        mode="diff"
        value={multiDiff}
        style={{width: '100%'}}/>);
  }


});
