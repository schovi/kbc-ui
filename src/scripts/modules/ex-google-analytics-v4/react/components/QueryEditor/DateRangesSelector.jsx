import React, {PropTypes} from 'react';
import {fromJS} from 'immutable';

export default React.createClass({
  propTypes: {
    ranges: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="form-group form-group-sme">
        <label className="control-label col-md-12">
          Date Ranges:
        </label>
        <div className="col-xs-12">
          <div className="table table-condensed">
            <div className="thead">
              <div className="tr">
                <div className="th">
                  <strong>Since </strong>
                </div>
                <div className="th">
                  <strong>Until </strong>
                </div>
                <div className="th">
                  <span onClick={this.addRange}
                    className="fa fa-fw fa-plus kbc-cursor-pointer" />
                </div>
              </div>
            </div>
            <div className="tbody">
              {this.props.ranges.map((r, idx) => this.renderRange(r, idx))}
            </div>
          </div>
        </div>
      </div>
    );
  },

  renderRange(range, idx) {
    return (
      <div className="tr">
        <div className="td" >
          <input
            type="text"
            className="form-control input-sm"
            value={range.get('startDate')}
            onChange={this.createUpdateFn('startDate', idx)}
          />
        </div>
        <div className="td">
          <input
            className="form-control input-sm"
            value={range.get('endDate')}
            onChange={this.createUpdateFn('endDate', idx)}
          />
        </div>
        <div className="td">
          { idx === 0 ?
            null
            :
            <span onClick={() => this.deleteRange(idx)}
              className="kbc-icon-cup kbc-cursor-pointer" />
          }
        </div>

      </div>

    );
  },

  addRange() {
    const newRange = fromJS({
      'startDate': '',
      'endDate': ''
    });
    this.props.onChange(this.props.ranges.push(newRange));
  },

  deleteRange(idx) {
    this.props.onChange(this.props.ranges.delete(idx));
  },

  createUpdateFn(propName, idx) {
    return (e) => {
      const value = e.target.value;
      const newRanges = this.props.ranges.map((r, ridx) => idx === ridx ? r.set(propName, value) : r);
      this.props.onChange(newRanges);
    };
  }

});
