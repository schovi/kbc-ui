import React from 'react';
import CreditSize from '../../../../../react/common/CreditSize';

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
            <dt>Input + Output</dt>
            <dd>
            {
              this.renderSize(
                this.props.metrics.get('storage').get('inBytes')
                + this.props.metrics.get('storage').get('outBytes')
              )
            }
            </dd>
          </dl>
          <p>
            <small>
              <i className="fa fa-info-circle" /> Input and output show total consumed credits.
              Shown numbers are processed asynchronously and may keep changing until processing is done.
            </small>
          </p>
        </div>
      );
    } else {
      return null;
    }
  },

  renderSize(nanoCredits) {
    if (nanoCredits !== 0) {
      return (
        <CreditSize nanoCredits={nanoCredits}/>
      );
    } else {
      return (
        '0 credits'
      );
    }
  }

});
