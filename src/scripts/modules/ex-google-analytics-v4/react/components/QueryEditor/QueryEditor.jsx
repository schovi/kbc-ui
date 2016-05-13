import React, {PropTypes} from 'react';
import {fromJS, List} from 'immutable';


import {sanitizeTableName} from '../../../common';


import ProfileSelector from './ProfileSelector';
import GaMultiSelect from './GaMultiSelect';
import DateRangesSelector from './DateRangesSelector';
import SapiTableLinkEx from '../../../../components/react/components/StorageApiTableLinkEx';

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
    isLoadingMetadata: PropTypes.bool.isRequired,
    isEditing: PropTypes.bool.isRequired,
    metadata: PropTypes.object.isRequired

  },

  componentDidMount() {

  },

  render() {
    const {query, isEditing} = this.props;
    const outTableId = this.props.outputBucket + '.' + query.get('outputTable');
    return (
      <div className={this.props.divClassName}>
        <div className="row kbc-header">
          <div className="form-horizontal">
            <div className="form-group">
              <label className="col-md-2 control-label">
                Name
              </label>
              <div className="col-md-6">
                {isEditing ?
                <input
                  type="text"
                  className="form-control"
                  value={query.get('name')}
                  placeholder="e.g. Untitled Query"
                  onChange={this.onChangeTextPropFn('name')}/>
                :
                <p className="form-control-static">
                  {query.get('name')}
                </p>
                }
              </div>
              <div className="col-md-4 checkbox">
                <label>
                  <input type="checkbox" checked={query.get('enabled')}
                    disabled={!isEditing}
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
                {isEditing ?
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
                 :
                 <p className="form-control-static">
                   <SapiTableLinkEx tableId={outTableId} />
                 </p>
                }
              </div>
            </div>
          </div>
        </div>
        <div className="row">
          <div className="form form-horizontal">
            <ProfileSelector
              isEditing={isEditing}
              allProfiles={this.props.allProfiles}
              selectedProfile={query.getIn(['query', 'viewId'])}
              onSelectProfile={this.onChangePropertyFn(['query', 'viewId']) }
            />
            <GaMultiSelect
              isLoadingMetadata={this.props.isLoadingMetadata}
              metadata={this.props.metadata.get('metrics', List()).toJS()}
              isEditing={isEditing}
              name="Metrics"
              onSelectValue={this.onSelectMetric}
              selectedValues={this.getSelectedMetrics()}
            />
            <GaMultiSelect
              isLoadingMetadata={this.props.isLoadingMetadata}
              metadata={this.props.metadata.get('dimensions', List()).toJS()}
              name="Dimensions"
              onSelectValue={this.onSelectDimension}
              selectedValues={this.getSelectedDimensions()}
              isEditing={isEditing}
            />
            <div className="form-group">
              <label className="col-md-4 control-label">
                Filters Expressions
              </label>
              <div className="col-md-10">
                {isEditing ?
                 <input
                   type="text"
                   className="form-control"
                   value={query.getIn(['query', 'filtersExpression'])}
                   onChange={this.onChangeTextPropFn(['query', 'filtersExpression'])}/>
                 :
                 <p className="form-control-static">
                   {query.getIn(['query', 'filtersExpression']) || 'N/A'}
                 </p>
                }

              </div>
            </div>
            <DateRangesSelector
              isEditing={isEditing}
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
