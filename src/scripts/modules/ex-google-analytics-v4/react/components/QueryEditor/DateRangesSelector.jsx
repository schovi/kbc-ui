import React, {PropTypes} from 'react';
import {fromJS} from 'immutable';
// import DateInput from './DateInput';
export default React.createClass({
  propTypes: {
    ranges: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    isEditing: PropTypes.bool.isRequired
  },

  render() {
    return (
      <div className="form-group form-group-sme">
        <label className="control-label col-md-12">
          Date Ranges:
        </label>
        <div className="col-xs-6">
          <div className="table">
            <div className="thead">
              <div className="tr">
                <div className="th">
                  <strong>Since</strong>
                </div>
                <div className="th">
                  <strong>Until</strong>
                </div>
                <div className="th">
                </div>
              </div>
            </div>
            <div className="tbody">
              {this.props.ranges.map((r, idx) => this.renderRange(r, idx))}
              {this.props.isEditing ?
               <div className="tr">
                 <button className="btn btn-link" onClick={this.addRange}>
                   Add Date Range
                 </button>
               </div>
               : null
              }
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
          {range.get('startDate')}
        </div>
        <div className="td" >
          {range.get('endDate')}
        </div>
        { (!this.props.isEditing) ?
          <div className="td"></div>
          :
          <div className="td">
            {/* <span className="btn btn-link" onClick={() => this.editRange(range, idx)}>
            <i className="fa fa-fw kbc-icon-pencil" />
            </span> */}
            { idx !== 0 ?
              <span className="btn btn-link" onClick={() => this.deleteRange(idx)}>
                <i className="kbc-icon-cup kbc-cursor-pointer" />
              </span> : null
            }
          </div>
        }
      </div>

    );
  },

  addRange() {
    const newRange = fromJS({
      'startDate': '-4 days',
      'endDate': 'now'
    });
    this.props.onChange(this.props.ranges.push(newRange));
  },

  editRange(range, idx) {
    // update local state editRangeModal with range and idx
    return idx;
  },

  deleteRange(idx) {
    this.props.onChange(this.props.ranges.delete(idx));
  },

  createUpdateFn(propName, idx) {
    return (e) => {
      const value = e;
      const newRanges = this.props.ranges.map((r, ridx) => idx === ridx ? r.set(propName, value) : r);
      this.props.onChange(newRanges);
    };
  }

});
