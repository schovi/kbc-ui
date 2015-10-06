import React from 'react';
import Immutable, {Map} from 'immutable';
import _ from 'underscore';
import Promise from 'bluebird';
import moment from 'moment';
import filesize from 'filesize';

import storageActions from '../../StorageActionCreators';
import storageApi from '../../StorageApi';
import tablesStore from '../../stores/StorageTablesStore';

import TableLinkModalDialog from './StorageApiTableLinkExComponents/ModalDialog';
import Tooltip from '../../../../react/common/Tooltip';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import EventsService from '../../../sapi-events/EventService';

export default React.createClass({

  mixins: [createStoreMixin(tablesStore)],

  propTypes: {
    tableId: React.PropTypes.string.isRequired,
    linkLabel: React.PropTypes.string,
    children: React.PropTypes.any
  },

  getStateFromStores(){
    const isLoading = tablesStore.getIsLoading();
    const tables = tablesStore.getAll() || Map();
    const table = tables.get(this.props.tableId, Map());

    return {
      table: table,
      isLoading: isLoading
    };
  },


  componentDidMount(){
    storageActions.loadTables();//.then(() => this.exportDataSample());
  },

  componentWilUnmount(){
    this.stopEventService();
  },

  /* shouldComponentUpdate(nextProps, nextState){
     return (nextState.show === true || this.state.show === true || nextState.isLoading === false) && nextState !== this.state;
     }, */


  getInitialState(){
    const omitFetches = true, omitExports = false;
    const es = EventsService.factory({limit: 10});
    const eventQuery = this.prepareEventQuery(omitFetches, omitExports);
    es.setQuery(eventQuery);

    return ({
      eventService: es,
      events: Immutable.List(),
      show: false,
      dataPreview: Immutable.List(),
      loadingPreview: false,
      omitFetches: omitFetches,
      omitExports: omitExports
    });
  },

  render(){
    return (
      <span key="mainspan">
        {this.renderLink()}
        {this.state.show ? this.renderModal() : (<span></span>)}
      </span>
    );
  },

  renderLink(){
    return (
      <Tooltip key="tooltip"
                 tooltip={this.renderTooltip()}
                 placement="top">
           <span key="buttonlink" className="kbc-sapi-table-link"
                 onClick={this.onShow}>
                 {this.props.children || this.props.linkLabel || this.props.tableId}
           </span>
       </Tooltip>
    );

  },

  renderTooltip(){
    if (this.state.isLoading){
      return 'Loading';
    }

    const table = this.state.table;
    if (!this.tableExists()){
      return 'Table does not exist yet.';
    }

    return (
      <span key="tooltipinfo">
        <div>
          {moment(table.get('lastChangeDate')).fromNow()}
        </div>
        <div>
          {filesize(table.get('dataSizeBytes'))}
        </div>
        <div>
          {table.get('rowsCount')} rows
        </div>
      </span>
    );
  },

  renderModal(){
    return (
      <TableLinkModalDialog
         show={this.state.show}
         tableId={this.props.tableId}
         reload={this.reload}
         tableExists={this.tableExists()}
         omitFetches={this.state.omitFetches}
         omitExports={this.state.omitExports}
         onHideFn={this.onHide}
         isLoading={this.isLoading()}
         table={this.state.table}
         dataPreview={this.state.dataPreview}
         onOmitExportsFn={this.onOmitExports}
         onOmitFetchesFn={this.onOmitFetches}
         events={this.state.events}
      />

    );

  },

  onOmitExports(e){
    const checked = e.target.checked;
    this.setState({omitExports: checked});
    const q = this.prepareEventQuery(this.state.omitFetches, checked);
    this.state.eventService.setQuery(q);
    this.state.eventService.load();

  },

  onOmitFetches(e){
    const checked = e.target.checked;
    this.setState({omitFetches: checked});
    const q = this.prepareEventQuery(checked, this.state.omitExports);
    this.state.eventService.setQuery(q);
    this.state.eventService.load();

  },

  prepareEventQuery(omitFetches, omitExports)
  {
    const defs = [omitFetches, omitExports];
    const omitsQuery = _.filter(['tableDetail', 'tableExported'], (val, idx) => defs[idx]
    ).map((ev) => `NOT event:storage.${ev}`);
    const objectIdQuery = `objectId:${this.props.tableId}`;
    const query = _.isEmpty(omitsQuery) ? objectIdQuery : `(${omitsQuery.join(' OR ')} AND ${objectIdQuery})`;
    return query;

  },

  isLoading(){
    return this.state.isLoading || this.state.loadingPreview || this.state.eventService.getIsLoading();

  },

  onHide(){
    this.setState({show: false});
    this.stopEventService();
  },

  reload(){
    Promise.props( {
      'loadAllTablesFore': storageActions.loadTablesForce(),
      'exportData': this.exportDataSample(),
      'loadEvents': this.state.eventService.load()
    });
  },

  onShow(e){
    this.exportDataSample();
    this.startEventService();
    this.setState({show: true});
    e.stopPropagation();
    e.preventDefault();
  },



  startEventService(){
    this.state.eventService.addChangeListener(this.handleEventsChange);
    this.state.eventService.load();
  },

  stopEventService(){
    this.state.eventService.stopAutoReload();
    this.state.eventService.removeChangeListener(this.handleEventsChange);
  },

  handleEventsChange(){
    const events = this.state.eventService.getEvents();
    this.setState({events: events});
  },

  exportDataSample(){
    if (!this.tableExists())
    {
      return false;
    }

    this.setState({
      loadingPreview: true
    });
    const component = this;
    return storageApi
    .exportTable(this.props.tableId, {limit: 10})
    .then( (csv) => {
      component.setState({
        loadingPreview: false,
        dataPreview: Immutable.fromJS(csv)
      });
    });

  },

  tableExists(){
    return !_.isEmpty(this.state.table.toJS());
  }


});
