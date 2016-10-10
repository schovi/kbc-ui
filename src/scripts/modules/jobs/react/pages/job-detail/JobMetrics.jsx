import React from 'react';
import FileSize from '../../../../../react/common/FileSize';

export default React.createClass({

  propTypes: {
    metrics: React.PropTypes.object.isRequired
  },

  render() {
    if (!this.props.metrics.isEmpty()) {
      return (
        <div>
          <h4>Storage IO</h4>
          <dl className="dl-horizontal">
            <dt>Input</dt>
            <dd>{this.renderSize(this.props.metrics.get('storage').get('inBytes'))}</dd>
            <dt>Output</dt>
            <dd>{this.renderSize(this.props.metrics.get('storage').get('outBytes'))}</dd>
          </dl>
          <small>
            <i className="fa fa-info-circle" /> Input and output show total transferred bytes (compressed and uncompressed).
            Shown numbers are processed asynchronously and may keep changing until processing is done.
          </small>
        </div>
      );
    } else {
      return null;
    }
  },

  renderSize(sizeInBytes) {
    if (sizeInBytes !== 0) {
      return (
        <FileSize size={sizeInBytes}/>
      );
    } else {
      return (
        '0 B'
      );
    }
  }

});
