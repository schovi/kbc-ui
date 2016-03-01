import React, {PropTypes} from  'react';

export default React.createClass({
  propTypes: {
    valueCurrent: PropTypes.number.isRequired,
    valueMax: PropTypes.number.isRequired
  },

  render() {
    return (
      <div className="kbc-limit-progress">
        <div className="progress">
          <div className="progress-bar" role="progressbar" aria-valuenow={this.props.valueCurrent} aria-valuemin="0" aria-valuemax={this.props.valueMax} style={this.barStyle()}>
            <span className="progress-value">{this.props.valueCurrent}</span>
          </div>
        </div>
      </div>
    );
  },

  barStyle() {
    return {
      width: `${this.props.valueCurrent / this.props.valueMax * 100}%`
    };
  }
});