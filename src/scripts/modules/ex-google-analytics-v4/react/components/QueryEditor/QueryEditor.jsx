import React, {PropTypes} from 'react';
import {fromJS, List} from 'immutable';


import {sanitizeTableName} from '../../../common';
import {GapiActions} from '../../../../google-utils/react/GapiFlux';

import ProfileSelector from './ProfileSelector';
import GaMultiSelect from './GaMultiSelect';
import DateRangesSelector from './DateRangesSelector';

export default React.createClass({
  propTypes: {
    allProfiles: PropTypes.object.isRequired,
    query: PropTypes.object.isRequired,
    divClassName: PropTypes.string.isRequired,
    outputBucket: PropTypes.string.isRequired,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onChangeQuery: PropTypes.func.isRequired,
    isGaInitialized: PropTypes.bool.isRequired,
    isLoadingMetadata: PropTypes.bool.isRequired,
    metadata: PropTypes.object.isRequired

  },

  componentDidMount() {
    GapiActions.loadAnalyticsMetadata();
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
                    <small>{this.props.outputBucket}</small>.
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
          <div className="form form-horizontal">
            <ProfileSelector
              allProfiles={this.props.allProfiles}
              selectedProfile={query.getIn(['query', 'viewId'])}
              onSelectProfile={this.onChangePropertyFn(['query', 'viewId']) }
            />
            <GaMultiSelect
              isLoadingMetadata={this.props.isLoadingMetadata}
              metadata={this.props.metadata.get('metrics', List()).toJS()}
              isGaInitialized={this.props.isGaInitialized}
              name="Metrics"
              onSelectValue={this.onSelectMetric}
              selectedValues={this.getSelectedMetrics()}
            />
            <GaMultiSelect
              isLoadingMetadata={this.props.isLoadingMetadata}
              metadata={this.props.metadata.get('dimensions', List()).toJS()}
              isGaInitialized={this.props.isGaInitialized}
              name="Dimensions"
              onSelectValue={this.onSelectDimension}
              selectedValues={this.getSelectedDimensions()}
            />
            <div className="form-group">
              <label className="col-md-4 control-label">
               Filters Expressions
              </label>
              <div className="col-md-10">
                <input
                  type="text"
                  className="form-control"
                  value={query.getIn(['query', 'filtersExpression'])}
                  onChange={this.onChangeTextPropFn(['query', 'filtersExpression'])}/>
              </div>
            </div>
            <DateRangesSelector
              ranges={query.getIn(['query', 'dateRanges'], List())}
              onChange={this.onChangePropertyFn(['query', 'dateRanges'])}
            />

          </div>
        </div>
      </div>
    );
  },

  onSelectMetric(strMetrics) {
    let metricsArray = [];
    for ( let metric of strMetrics.split(',')) {
      if (metricsArray.indexOf(metric) < 0) {
        metricsArray.push(metric);
      }
    }
    const newMetrics = fromJS(metricsArray.map((m) => {return {expression: m};}));
    const newQuery = this.props.query.setIn(['query', 'metrics'], newMetrics);
    this.props.onChangeQuery(newQuery);
  },

  getSelectedMetrics() {
    const metrics = this.props.query.getIn(['query', 'metrics'], List());
    return metrics.map((m) => m.get('expression')).toArray();
  },

  onSelectDimension(strDimensions) {
    let dimensionsArray = [];
    for ( let dimension of strDimensions.split(',')) {
      if (dimensionsArray.indexOf(dimension) < 0) {
        dimensionsArray.push(dimension);
      }
    }
    const newDimensions = fromJS(dimensionsArray.map((m) => {return {name: m};}));
    const newQuery = this.props.query.setIn(['query', 'dimensions'], newDimensions);
    this.props.onChangeQuery(newQuery);
  },

  getSelectedDimensions() {
    const dimensions = this.props.query.getIn(['query', 'dimensions'], List());
    return dimensions.map((m) => m.get('name')).toArray();
  },

  onChangePropertyFn(propName, getValueFnParam) {
    let getValueFn = getValueFnParam;
    if (!getValueFn) {
      getValueFn = (value) => value;
    }
    const changeFn = (event) => {
      const value = getValueFn(event);
      const newQuery = this.props.query.setIn([].concat(propName), value);
      this.props.onChangeQuery(newQuery);
    };
    return changeFn;
  },

  onChangeTextPropFn(propName) {
    const changeFn = (ev) => {
      const value = ev.target.value;
      const newQuery = this.props.query.setIn([].concat(propName), value);
      this.props.onChangeQuery(newQuery);
    };
    return changeFn;
  }
});
