import React from 'react';
import {Map, List} from 'immutable';

import createStoreMixin from '../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../stores/RoutesStore';
import InstalledComponentStore from '../../components/stores/InstalledComponentsStore';
import ComponentStore from '../../components/stores/ComponentsStore';
import LatestJobsStore from '../../jobs/stores/LatestJobsStore';

import EmptyState from '../../components/react/components/ComponentEmptyState';
import ComponentDescription from '../../components/react/components/ComponentDescription';
import ComponentMetadata from '../../components/react/components/ComponentMetadata';
import RunComponentButton from '../../components/react/components/RunComponentButton';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';
import LatestJobs from '../../components/react/components/SidebarJobs';
import CredentialsModal from './CredentialsModal';
import TemplateModal from './TemplateModal';
import Configuration from '../../components/react/components/Configuration';
import {saveCredentials,
  cancelCredentialsEdit,
  updateLocalState,
  jobsEditStart,
  jobsEditChange,
  jobsEditCancel,
  jobsEditSubmit,
  changeTemplate,
  initFromTemplate,
  prefillFromTemplate
  } from '../actions';

import templates from '../jobsTemplates';
import Select from 'react-select';
import {Button} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  mixins: [createStoreMixin(InstalledComponentStore, LatestJobsStore, ComponentStore)],

  getStateFromStores() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = 'ex-adform',
      localState = InstalledComponentStore.getLocalState(componentId, configId);

    return {
      component: ComponentStore.getComponent(componentId),
      componentId: componentId,
      parameters: InstalledComponentStore.getConfigData(componentId, configId).get('parameters', Map()),
      config: InstalledComponentStore.getConfig(componentId, configId),
      latestJobs: LatestJobsStore.getJobs(componentId, configId),
      isSaving: InstalledComponentStore.isSavingConfigData(componentId, configId),
      localState: localState,
      isEditingJobs: localState.has('jobsString')
    };
  },

  getInitialState() {
    return {
      showCredentialsModal: false,
      showTemplateModal: false
    };
  },


  render() {
    return (
      <div className="container-fluid">
        <div className="col-md-9 kbc-main-content">
          <div className="row kbc-header">
            <ComponentDescription
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
              />
          </div>
          <div className="row">
            <div classNmae="col-xs-4">
              {this.renderMainContent()}
            </div>
          </div>
        </div>
        <div className="col-md-3 kbc-main-sidebar">
          <div classNmae="kbc-buttons kbc-text-light">
            {this.renderAuthorizedSidebarRow()}
            <ComponentMetadata
              componentId={this.state.componentId}
              configId={this.state.config.get('id')}
              />
          </div>
          <ul className="nav nav-stacked">
            <li>
              <a onClick={this.openCredentialsModal}>
                <i className="fa fa-fw fa-user"/>
                Credentials
              </a>
              <CredentialsModal
                show={this.state.showCredentialsModal}
                onHide={this.closeCredentialsModal}
                credentials={this.state.localState.get('credentials', Map({
                  username: this.state.parameters.getIn(['config', 'username'], ''),
                  password: this.state.parameters.getIn(['config', 'password'], '')
                }))}
                isSaving={this.state.isSaving}
                onChange={this.updateCredentials}
                onSave={this.saveCredentials}
                />
            </li>
            <li>
              <RunComponentButton
                title="Run"
                component={this.state.componentId}
                mode="link"
                runParams={this.runParams()}
                >
                You are about to run component.
              </RunComponentButton>
            </li>
            <li>
              <DeleteConfigurationButton
                componentId={this.state.componentId}
                configId={this.state.config.get('id')}
                />
            </li>
          </ul>
          <LatestJobs jobs={this.state.latestJobs} />
        </div>
      </div>
    );
  },

  renderMainContent() {
    if (!this.isAuthorized()) {
      return (
        <EmptyState>
          <p>Please setup credentials for this extractor.</p>
          <button className="btn btn-success" onClick={this.openCredentialsModal}>
            Setup Credentials
          </button>
        </EmptyState>
      );
    } else if (!this.state.parameters.hasIn(['config', 'jobs'])) {
      return (
        <div>
          {this.renderInitFromTemplate()}
        </div>
      );
    } else {
      return (
        <div>
          {this.renderHelp()}
          <Configuration
            data={this.getJobsData()}
            isEditing={this.state.isEditingJobs}
            isSaving={this.state.isSaving}
            onEditStart={this.onJobsEditStart}
            onEditCancel={this.onJobsEditCancel}
            onEditChange={this.onJobsEditChange}
            onEditSubmit={this.onJobsEditSubmit}
            isValid={this.isValidJobsData()}
            headerText="Resources"
            help={this.renderPrefillFromTemplate()}
            />
        </div>
      );
    }
  },

  renderHelp() {
    return (
      <p className="help-block">
        Adform resources to fetch has to be configured manually.
        The resource configuration bellow expect <strong>jobs</strong> array configured according to
        <a href="https://github.com/keboola/generic-extractor#jobs" target="_blank"> documentation</a>.
      </p>
    );
  },

  getJobsData() {
    if(this.state.isEditingJobs) {
      return this.state.localState.get('jobsString');
    } else {
      return JSON.stringify(this.state.parameters.getIn(['config', 'jobs'], List()).toJSON(), null, '  ');
    }
  },

  isValidJobsData() {
    try {
      JSON.parse(this.state.localState.get('jobsString'));
      return true;
    } catch (e) {
      return false;
    }
  },

  isAuthorized() {
    return this.state.parameters.getIn(['config', 'username'])
      && this.state.parameters.getIn(['config', 'password']);
  },

  renderInitFromTemplate() {
    return (
      <div>
        <p>Please select from predefined templates:</p>
        <p>
          <Select
            name="jobTemplates"
            value={this.state.localState.get('template')}
            options={this.templatesOptions()}
            onChange={this.onTemplateChange}
            placeholder="Select template"
            />
        </p>
        <p>
          <Button
            bsStyle="success"
            disabled={this.state.isSaving || !this.state.localState.get('template')}
            onClick={this.onInitFromTemplate}
            >
            Create
          </Button> {this.isSaving ? <Loader/> : null}
        </p>
      </div>
    );
  },

  renderPrefillFromTemplate() {
    if (this.state.isEditingJobs) {
      return (
        <div>
          <p>
            <Button
              bsStyle="link"
              onClick={this.openTemplateModal}
              >
              <span className="fa fa-folder-open"/> Configure from template
            </Button>
            <TemplateModal
              show={this.state.showTemplateModal}
              template={this.state.localState.get('template', '')}
              templates={this.templatesOptions()}
              onChange={this.onTemplateChange}
              onSubmit={this.onPrefillFromTemplate}
              onHide={this.closeTemplateModal}
              />
          </p>
        </div>
      );
    } else {
      return null;
    }
  },

  templatesOptions() {
    return templates.map((template) => {
      return Map({
        label: template.get('name'),
        value: template.get('id')
      });
    }).toJS();
  },

  renderAuthorizedSidebarRow() {
    if (this.isAuthorized()) {
      return (
        <span>Authorized for <strong>{this.state.parameters.getIn(['config', 'username'])}</strong></span>
      );
    }
  },

  updateCredentials(newCredentials) {
    this.updateLocalState(['credentials'], newCredentials);
  },

  openCredentialsModal() {
    this.setState({
      showCredentialsModal: true
    });
  },

  closeCredentialsModal() {
    this.setState({
      showCredentialsModal: false
    });
    cancelCredentialsEdit(this.state.config.get('id'));
  },

  openTemplateModal() {
    this.setState({
      showTemplateModal: true
    });
  },

  closeTemplateModal() {
    this.setState({
      showTemplateModal: false
    });
  },


  saveCredentials() {
    return saveCredentials(this.state.config.get('id'));
  },

  updateLocalState(path, value) {
    const newState = this.state.localState.setIn(path, value);
    updateLocalState(this.state.config.get('id'), newState);
  },

  runParams() {
    return () => ({config: this.state.config.get('id')});
  },

  onJobsEditStart() {
    jobsEditStart(this.state.config.get('id'));
  },

  onJobsEditCancel() {
    jobsEditCancel(this.state.config.get('id'));
  },

  onJobsEditChange(newValue) {
    jobsEditChange(this.state.config.get('id'), newValue);
  },

  onJobsEditSubmit() {
    jobsEditSubmit(this.state.config.get('id'));
  },

  onTemplateChange(templateId) {
    changeTemplate(this.state.config.get('id'), templateId);
  },

  onInitFromTemplate() {
    initFromTemplate(this.state.config.get('id'));
  },

  onPrefillFromTemplate() {
    prefillFromTemplate(this.state.config.get('id'));
  }

});
