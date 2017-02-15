import React, {PropTypes} from 'react';
import {Map, fromJS, List} from 'immutable';
import {sanitizeTableName} from '../../../common';
import ProfileSelector from './ProfileSelector';
import GaMultiSelect from './GaMultiSelect';
import DateRangesSelector from './DateRangesSelector';
import SapiTableLinkEx from '../../../../components/react/components/StorageApiTableLinkEx';
import QuerySample from './QuerySample';
import UrlParserModal from './UrlParserModal';
import AntiSamplingModal from './AntiSamplingModal';

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
    onRunQuery: PropTypes.func.isRequired,
    isLoadingMetadata: PropTypes.bool.isRequired,
    isEditing: PropTypes.bool.isRequired,
    metadata: PropTypes.object.isRequired,
    sampleDataInfo: PropTypes.object.isRequired,
    accountSegments: PropTypes.object.isRequired,
    isQueryValidFn: PropTypes.func
  },

  render() {
    const {query, isEditing} = this.props;
    const outTableId = this.props.outputBucket + '.' + query.get('outputTable');
    return (
      <div className="row">
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
            <div className="col-md-2 checkbox">
              <label>
                <input type="checkbox" checked={query.get('enabled')}
                  disabled={!isEditing}
                  onChange={this.onChangePropertyFn('enabled', (e) => e.target.checked)}/>
                Enabled
              </label>
            </div>
            <div className="col-md-2">
              {isEditing ? this.renderUrlParser() : null}
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
          <GaMultiSelect
            isLoadingMetadata={this.props.accountSegments.get('isLoading')}
            metadata={this.props.accountSegments.get('data', List()).toJS()}
            name="Segments"
            onSelectValue={this.onSelectSegment}
            selectedValues={this.getSelectedSegments()}
            isEditing={isEditing}
          />
          <div className="form-group">
            <label className="col-md-2 control-label">
              Filters
            </label>
            <div className="col-md-10">
              {isEditing ?
               <input
                 type="text"
                 placeholder="e.g ga:sourceMedium=~(something)"
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

          <div className="form-group">
            <label className="col-md-2 control-label">
              {this.renderOptionsModal()}
              Anti-sampling
            </label>
            <div className="col-md-9 pull-left">
              {isEditing ?
               <span className="btn btn-link form-control-static"
                 onClick={this.openOptionsDialogModal}>
                 {query.get('antisampling') || 'None'}
                 {' '}
                 <span className="kbc-icon-pencil" />
               </span>
               :
               <p className="form-control-static">
                 {query.get('antisampling') || 'None'}
               </p>
              }
            </div>
          </div>

          <DateRangesSelector
            isEditing={isEditing}
            ranges={query.getIn(['query', 'dateRanges'], List())}
            onChange={this.onChangePropertyFn(['query', 'dateRanges'])}
            {...this.props.prepareLocalState('DateRangeSelector')}/>


        </div>
        <QuerySample
          onRunQuery={() => this.props.onRunQuery(this.props.query)}
          isQueryValid={this.props.isQueryValidFn(this.props.query)}
          sampleDataInfo={this.props.sampleDataInfo}
        />
      </div>
    );
  },

  openOptionsDialogModal() {
    const stav = {
      show: true,
      value: this.props.query.get('antisampling', null)
    };
    this.props.updateLocalState(['OptionsModal'], fromJS(stav));
  },

  renderOptionsModal() {
    const {query, onChangeQuery} = this.props;
    const path = ['OptionsModal'];
    const ls = this.props.localState.getIn(path, Map());
    return (
      <AntiSamplingModal
        show={ls.get('show', false)}
        onHideFn={() => this.props.updateLocalState(path, Map())}
        onSaveFn={(newVal) => onChangeQuery(query.set('antisampling', newVal))}
        {...this.props.prepareLocalState(path)}
      />
    );
  },


  renderUrlParser() {
    const {localState, query, onChangeQuery} = this.props;
    return (
      <span>
        <button onClick={() => this.props.updateLocalState('showUrlParser', true)}
          className="btn btn-primary btn-sm">
          Parse Query Url
        </button>
        <UrlParserModal
          onSave={(newQuery) => onChangeQuery(query.set('query', newQuery))}
          show={localState.get('showUrlParser', false)}
          onCancel={() => this.props.updateLocalState('showUrlParser', false)}
          {...this.props.prepareLocalState('UrlParser')}/>
      </span>
    );
  },

  onSelectMetric(strMetrics) {
    let metricsArray = [];
    if (strMetrics && strMetrics !== '') {
      for ( let metric of strMetrics.split(',')) {
        if (metricsArray.indexOf(metric) < 0) {
          metricsArray.push(metric);
        }
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
    if (strDimensions && strDimensions !== '') {
      for ( let dimension of strDimensions.split(',')) {
        if (dimensionsArray.indexOf(dimension) < 0) {
          dimensionsArray.push(dimension);
        }
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

  onSelectSegment(strSegments) {
    let segmentsArray = [];
    if (strSegments && strSegments !== '') {
      for ( let segment of strSegments.split(',')) {
        if (segmentsArray.indexOf(segment) < 0) {
          segmentsArray.push(segment);
        }
      }
    }
    const newSegments = fromJS(segmentsArray.map((m) => {return {segmentId: m};}));
    const newQuery = this.props.query.setIn(['query', 'segments'], newSegments);
    this.props.onChangeQuery(newQuery);
  },

  getSelectedSegments() {
    const segments = this.props.query.getIn(['query', 'segments'], List());
    return segments.map((m) => m.get('segmentId')).toArray();
  },

  onChangePropertyFn(propName, getValueFnParam) {
    let getValueFn = getValueFnParam;
    if (!getValueFn) {
      getValueFn = (value) => value;
    }
    return (event) => {
      const value = getValueFn(event);
      const newQuery = this.props.query.setIn([].concat(propName), value);
      this.props.onChangeQuery(newQuery);
    };
  },

  onChangeTextPropFn(propName) {
    return (ev) => {
      const value = ev.target.value;
      const newQuery = this.props.query.setIn([].concat(propName), value);
      this.props.onChangeQuery(newQuery);
    };
  }
});
