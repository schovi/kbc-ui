import React from 'react';
import {Map} from 'immutable';
import {FormControls} from 'react-bootstrap';
const StaticText = FormControls.Static;
import installedComponentsActions from '../../components/InstalledComponentsActionCreators';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../components/stores/ComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';

//import EmptyState from '../../components/react/components/ComponentEmptyState';
import ComponentDescription from '../../components/react/components/ComponentDescription';
//import ComponentMetadata from '../../components/react/components/ComponentMetadata';
//import RunComponentButton from '../../components/react/components/RunComponentButton';
//import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
//import LatestJobs from '../../components/react/components/SidebarJobs';

const componentId = 'geneea-nlp-analysis';


const BETA = 'use_beta';
const LANGUAGE = 'language';
const OUTPUT = 'output';
const PRIMARYKEY = 'id_column';
const ANALYSIS = 'anayslisi_types';
const DATACOLUMN = 'data_column';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore)],

  getStateFromStores(){
    const configId = RoutesStore.getCurrentRouteParam('config');
    const localState = InstalledComponentStore.getLocalState(componentId, configId);
    const configData = InstalledComponentStore.getConfigData(componentId, configId);
    const intable = configData.getIn(['storage', 'input', 'tables', 0], Map()).get('source');
    const parameters = configData.get('parameters');

    //console.log('CONFIG DATA', configData);
    return {
      configId: configId,
      localState: localState,
      configData: configData,
      intable: intable,
      parameters: parameters

    };
  },

  parameter(key, defaultValue){
    return this.state.parameters.get(key, defaultValue);
  },

  render(){
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={componentId}
              configId={this.state.configId}
            />
          </div>
          <div className="row">
            <form className="form-horizontal">
              {this.renderStatic()}
            </form>
          </div>
        </div>
      </div>
    );
  },

  renderStatic(){
    return (
      <div className="row">
        {this.RenderStaticInput('Input table', this.state.intable)}
        {this.RenderStaticInput('Data column', this.parameter(DATACOLUMN))}
        {this.RenderStaticInput('Primary Key', this.parameter(PRIMARYKEY))}
        {this.RenderStaticInput('Output table prefix', this.parameter(OUTPUT))}
        {this.RenderStaticInput('Language', this.parameter(LANGUAGE))}
        {this.RenderStaticInput('Use beta', this.parameter(BETA))}
        {this.RenderStaticInput('Analysis taks', this.parameter(ANALYSIS, []).join(','))}
      </div>
    );
  },

  RenderStaticInput(label, value){
    return (
      <StaticText
        label={label}
        labelClassName="col-xs-4"
        wrapperClassName="col-xs-8">
        {value || 'n/a'}
      </StaticText>
    );
  },

  updateLocalState(path, data){
    const newState = this.state.localState.setIn(path, data);
    installedComponentsActions.updateLocalState(componentId, this.state.configId, newState);
  }

});
