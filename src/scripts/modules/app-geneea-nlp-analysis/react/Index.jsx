import React from 'react';
import {List, Map} from 'immutable';
import _ from 'underscore';
import {FormControls} from 'react-bootstrap';
import Select from 'react-select';
import {Check} from 'kbc-react-components';
import classnames from 'classnames';

import SapiTableSelector from '../../components/react/components/SapiTableSelector';

const StaticText = FormControls.Static;
//import installedComponentsActions from '../../components/InstalledComponentsActionCreators';
import {params,
  getInTable,
  updateLocalState,
  updateEditingValue,
  getEditingValue} from '../actions';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';
import storageTablesStore from '../../components/stores/StorageTablesStore';

//import EmptyState from '../../components/react/components/ComponentEmptyState';
import ComponentDescription from '../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
import LatestJobs from '../../components/react/components/SidebarJobs';

const componentId = 'geneea-nlp-analysis';

const analysisTypes = {
  language: {
    name: 'Language',
    tooltip: 'Detect Language'

  },
  lemmatize: {
    name: 'Lemmatization',
    tooltip: 'Lemmatization'

  },
  correction: {
    name: 'Correction',
    tooltip: 'Correction'

  },
  topic: {
    name: 'Topic Detection',
    tooltip: 'Topic Detection'
  },

  sentiment: {
    name: 'Sentiment Analysis',
    tooltip: 'Sentiment Analysis'

  },
  entities: {
    name: 'Entities Detection',
    tooltip: 'Entities Detection'

  },
  hashtags: {
    name: 'Hashtags',
    tooltip: 'Hashtags'
  }

};

const languageOptions = [
  {
    label: 'English',
    value: 'en'
  }
  ,
  {
    label: 'Czech',
    value: 'cs'
  }
];

export default React.createClass({
  mixins: [createStoreMixin(storageTablesStore, InstalledComponentStore, LatestJobsStore)],

  getStateFromStores(){
    const configId = RoutesStore.getCurrentRouteParam('config');
    const localState = InstalledComponentStore.getLocalState(componentId, configId);
    const configData = InstalledComponentStore.getConfigData(componentId, configId);

    const intable = getInTable(configId);
    const parameters = configData.get('parameters', Map());

    console.log('CONFIG DATA', localState.toJS(), configData.toJS());
    return {
      configId: configId,
      localState: localState,
      configData: configData,
      intable: intable,
      parameters: parameters,
      editing: !!localState.get('editing'),
      latestJobs: LatestJobsStore.getJobs(componentId, configId)

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
              { this.state.editing ? this.renderEditing() : this.renderStatic()}
            </form>
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            <ComponentMetadata
              componentId={componentId}
              configId={this.state.configId}
              />
          </div>
          <ul className="nav nav-stacked">
            <li className={classnames({disabled: this.state.editing})}>
              <RunComponentButton
                title="Run"
                component={componentId}
                mode="link"
                runParams={ {config: this.state.configId} }
                disabledReason="Configuration is not saved."
                disabled={this.state.editing}
                >
                You are about to run the analysis job.
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={componentId}
                configId={this.state.configId}
                />
            </li>
          </ul>
          <LatestJobs jobs={this.state.latestJobs} />
        </div>
      </div>
    );
  },

  renderEditing(){
    const intableChange = (value) => {
      this.updateEditingValue('intable', value);
      this.updateEditingValue(params.DATACOLUMN, '');
      this.updateEditingValue(params.PRIMARYKEY, '');
    };
    return (
      <div className="row">
        {this.renderEditFormElement('Input Table',
           <SapiTableSelector
            placeholder="Select..."
            value={this.getEditingValue('intable')}
            onSelectTableFn= {intableChange}
            excludeTableFn= { () => false}/>)
        }
        {this.renderColumnSelect('Data Column', params.DATACOLUMN)}
        {this.renderColumnSelect('Primary Key', params.PRIMARYKEY)}
        {this.renderEditFormElement('Output Table Prefix',
          <input
            className="form-control"
            value={this.getEditingValue(params.OUTPUT)}
            onChange= {(event) => this.updateEditingValue(params.OUTPUT, event.target.value)}
            placeholder="e.g. out.c-main.result"/>)
        }
        {this.renderEditFormElement('Language',
          <Select
            key="language"
            name="language"
            clearable={false}
            value={this.getEditingValue(params.LANGUAGE)}
            onChange= {(newValue) => this.updateEditingValue(params.LANGUAGE, newValue)}
            options= {languageOptions}/>)
        }
        {this.renderAnalysisTypesSelect()}
        {this.renderUseBetaEdit()}
      </div>
    );
  },

  renderAnalysisTypesSelect(){
    const selectedTypes = this.getEditingValue(params.ANALYSIS);
    const options = _.map( _.keys(analysisTypes), (value) => {
      const checked = (selectedTypes.indexOf(value) > -1);
      const onChange = (e) => {
        const isChecked = e.target.checked;
        const newSelected = isChecked ? selectedTypes.push(value) : selectedTypes.remove(value);
        this.updateEditingValue(params.ANALYSIS, newSelected);
      };
      const info = analysisTypes[value];
      return (
        <div className="checkbox">
          <label>
            <input

             type="checkbox"
             value={checked}
             onChange={onChange}/>
            <span>
              {info.name}
            </span>
          </label>
        </div>
      );
    }
    );

    return this.renderEditFormElement('Analysis types', options);

  },


  renderUseBetaEdit(){
    return (
      <div className="form-group">
        <div className="checkbox col-sm-3">
          <label>
            <input
              type="checkbox"
              value={this.getEditingValue(params.BETA)}
              onChange= {(event) => this.updateEditingValue(params.BETA, event.target.checked)}/>
          Use BETA Version
          </label>
        </div>
      </div>
      );
  },



  renderEditFormElement(label, element){
    return (
      <div className="form-group">
        <label className="control-label col-sm-3">
          {label}
        </label>
        <div className="col-sm-9">
          {element}
        </div>
      </div>
    );
  },

  renderColumnSelect(label, column){
    const result = this.renderEditFormElement(label,
      <Select
        clearable={false}
        key={column}
        name={column}
        value={this.getEditingValue(column)}
        onChange= {(newValue) => this.updateEditingValue(column, newValue)}
        options= {this.getColumns()}
      />
    );
    return result;

  },

  renderStatic(){
    const tasks = this.parameter(params.ANALYSIS, List()).map( (value) => analysisTypes[value].name);

    return (
      <div className="row">
        {this.RenderStaticInput('Input Table', this.state.intable)}
        {this.RenderStaticInput('Data Column', this.parameter(params.DATACOLUMN))}
        {this.RenderStaticInput('Primary Key', this.parameter(params.PRIMARYKEY))}
        {this.RenderStaticInput('Output Table Prefix', this.parameter(params.OUTPUT))}
        {this.RenderStaticInput('Language', this.parameter(params.LANGUAGE))}
        {this.RenderStaticInput('Analysis taks', tasks.join(', '))}
        {this.RenderStaticInput('Use beta', this.parameter(params.BETA), true)}
      </div>
    );
  },

  RenderStaticInput(label, value, isBetaCheckobx = false){
    return (
      <StaticText
        label={label}
        labelClassName="col-sm-3"
        wrapperClassName="col-sm-9">
        {isBetaCheckobx ? <Check
         isChecked={value}/> : value || 'n/a'}
      </StaticText>
    );
  },

  getColumns(){
    const tableId = this.getEditingValue('intable');
    const tables = storageTablesStore.getAll();

    if (!tableId || !tables){
      return [];
    }

    const table = tables.find((ptable) => {
      return ptable.get('id') === tableId;
    });

    if (!table){
      return [];
    }
    const result = table.get('columns').map( (column) =>
      {
        return {
          'label': column,
          'value': column
        };
      }
    ).toList().toJS();

    return result;
  },

  updateEditingValue(prop, value){
    updateEditingValue(this.state.configId, prop, value);
  },

  getEditingValue(prop){
    return getEditingValue(this.state.configId, prop);
  },

  updateLocalState(path, data){
    updateLocalState(this.state.configId, path, data);
  }

});
