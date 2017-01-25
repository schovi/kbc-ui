import React, {PropTypes} from 'react';
import LimitRow from './LimitRow';


function limitsToRows(limits) {
  return limits
    .toIndexedSeq()
    .groupBy((limit, i) => Math.floor(i / 3));
}

export default React.createClass({
  propTypes: {
    section: PropTypes.object.isRequired,
    isKeenReady: PropTypes.bool,
    keenClient: PropTypes.object.isRequired,
    canEdit: PropTypes.bool
  },
  render() {
    const {section} = this.props;
    return (
      <div className="kbc-limits-section">
        <div className="kbc-header">
          <div className="kbc-title">
            <h2>
               <span className="kb-sapi-component-icon">
                <img src={section.get('icon')} width="32" height="32"/>
              </span>
              {section.get('title')}
            </h2>
          </div>
        </div>
        <div className="table kbc-table-border-vertical kbc-components-overview kbc-layout-table">
          <div className="tbody">
            {limitsToRows(section.get('limits').filter(function(limit) {
              return limit.get('showOnLimitsPage', true);
            })).map(this.limitsRow)}
          </div>
        </div>
      </div>
    );
  },

  limitsRow(limitsPart) {
    const tds = limitsPart.map((limit) => {
      return React.createElement(LimitRow, {
        limit: limit,
        isKeenReady: this.props.isKeenReady,
        keenClient: this.props.keenClient,
        canEdit: this.props.canEdit,
        key: limit.get('id')
      });
    }, this);

    return (
      <div className="tr">
        {tds}
      </div>
    );
  }

});
