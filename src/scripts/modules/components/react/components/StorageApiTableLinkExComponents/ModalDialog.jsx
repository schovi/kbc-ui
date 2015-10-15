import React, {PropTypes} from 'react';

import EventsTab from './EventsTab';
import GeneralInfoTab from './GeneralInfoTab';
import DataSampleTab from './DataSampleTab';
import ColumnsInfoTab from './ColumnsInfoTab';

import SapiTableLink from '../StorageApiTableLink';
import immutableMixin from '../../../../../react/mixins/ImmutableRendererMixin';

import {TabbedArea, TabPane, Modal} from 'react-bootstrap';
import {RefreshIcon} from 'kbc-react-components';


export default React.createClass({

  propTypes: {
    show: PropTypes.bool.isRequired,
    tableId: PropTypes.string.isRequired,
    reload: PropTypes.func.isRequired,
    tableExists: PropTypes.bool.isRequired,
    omitFetches: PropTypes.bool,
    events: PropTypes.object.isRequired,
    omitExports: PropTypes.bool,
    isLoading: PropTypes.bool,
    loadingProfilerData: PropTypes.bool,
    table: PropTypes.object,
    dataPreview: PropTypes.object,
    enhancedAnalysis: PropTypes.object,
    onOmitFetchesFn: PropTypes.func,
    onOmitExportsFn: PropTypes.func,
    onHideFn: PropTypes.func,
    isRedshift: PropTypes.bool,
    onRunAnalysis: PropTypes.func,
    isCallingRunAnalysis: PropTypes.bool

  },

  mixins: [immutableMixin],

  render(){
    const modalBody = this.renderModalBody();
    let tableLink = (<small className="disabled btn btn-link"> Explore in Console</small>);
    if (this.props.tableExists){
      tableLink =
      (
        <SapiTableLink
          tableId={this.props.tableId}>
          <small className="btn btn-link">
            Explore in Console
          </small>
        </SapiTableLink>);
    }
    return (
      <div className="static-modal">
        <Modal
          bsSize="large"
          show={this.props.show}
          onHide={this.props.onHideFn}
          >
          <Modal.Header closeButton>
            <Modal.Title>
              {this.props.tableId}
              {tableLink}
              <RefreshIcon
                 isLoading={this.props.isLoading}
                 onClick={this.props.reload}
              />
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            {modalBody}
          </Modal.Body>
        </Modal>
      </div>
    );

  },

  renderModalBody(){
    return (
      <TabbedArea key="tabbedarea" animation={false}>
        <TabPane key="general" eventKey="general" tab="General Info">
          {this.renderGeneralInfo()}
        </TabPane>
        <TabPane key="columns" eventKey="columns" tab="Columns">
          {this.renderColumnsInfo()}
        </TabPane>
        <TabPane key="datasample" eventKey="datasample" tab="Data Sample">
          {this.renderDataSample()}
        </TabPane>
        <TabPane key="events" eventKey="events" tab="Events">
          {this.renderEvents()}
        </TabPane>
      </TabbedArea>
    );

  },

  renderGeneralInfo(){
    return (
      <GeneralInfoTab
        isLoading={this.props.isLoading}
        table={this.props.table}
        tableExists={this.props.tableExists}
      />
    );

  },

  renderEvents(){
    return (
      <EventsTab
        tableExists={this.props.tableExists}
        tableId={this.props.tableId}
        events={this.props.events}
        omitFetches={this.props.omitFetches}
        omitExports={this.props.omitExports}
        onOmitFetchesFn={this.props.onOmitFetchesFn}
        onOmitExportsFn={this.props.onOmitExportsFn}
      />

    );

  },

  renderDataSample(){
    return (
      <DataSampleTab
        dataPreview={this.props.dataPreview}
      />
    );

  },

  renderColumnsInfo(){
    return (
      <ColumnsInfoTab
        tableExists={this.props.tableExists}
        table={this.props.table}
        dataPreview={this.props.dataPreview}
        isRedshift={this.props.isRedshift}
        isCallingRunAnalysis={this.props.isCallingRunAnalysis}
        onRunAnalysis={this.props.onRunAnalysis}
        loadingProfilerData={this.props.loadingProfilerData}
        enhancedAnalysis={this.props.enhancedAnalysis}
      />
    );
  }

});
