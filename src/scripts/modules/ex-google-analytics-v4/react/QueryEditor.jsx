import React, {PropTypes} from 'react';
import {sanitizeTableName} from '../common';
export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    divClassName: PropTypes.string.isRequired,
    outputBucket: PropTypes.string.isRequired,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onChangeQuery: PropTypes.func.isRequired

  },

  render() {
    const {query} = this.props;
    return (
      <div className={this.props.divClassName}>
        <div className="row kbc-header">
          <div className="form-horizontal">
            <div className="form-group">
              <label className="col-md-2 control-label">
                Name
              </label>
              <div className="col-md-6">
                <input
                  type="text"
                  className="form-control"
                  value={query.get('name')}
                  placeholder="e.g. Untitled Query"
                  onChange={this.onChangeTextPropFn('name')}/>
              </div>
              <div className="col-md-4 checkbox">
                <label>
                  <input type="checkbox" checked={query.get('enabled')}
                    onChange={this.onChangePropertyFn('enabled', (e) => e.target.checked)}/>
                  Enabled
                </label>
              </div>
            </div>
            <div className="form-group">
              <label className="col-md-2 control-label">
                Output Table
              </label>
              <div className="col-md-8">
                <div className="input-group">
                  <div className="input-group-addon">
                    {this.props.outputBucket}.
                  </div>
                  <input
                    type="text"
                    className="form-control"
                    value={query.get('outputTable')}
                    placeholder={sanitizeTableName(query.get('name'))}
                    onChange={this.onChangeTextPropFn('outputTable')}/>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="row">
          Query editor: metrics, dimensions, filtersExporession, profile, dateranges
        </div>
      </div>
    );
  },

  onChangePropertyFn(propName, getValueFn) {
    const changeFn = (event) => {
      const value = getValueFn(event);
      const newQuery = this.props.query.set(propName, value);
      this.props.onChangeQuery(newQuery);
    };
    return changeFn;
  },

  onChangeTextPropFn(propName) {
    const changeFn = (ev) => {
      const value = ev.target.value;
      const newQuery = this.props.query.set(propName, value);
      this.props.onChangeQuery(newQuery);
    };
    return changeFn;
  }
});
