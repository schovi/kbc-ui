import Dispatcher from '../../../Dispatcher';
import StoreUtils from '../../../utils/StoreUtils';
import { Map } from 'immutable';

var dropboxStore = Map({
  fileNames: Map()
});


let ExDropboxStore = StoreUtils.createStore({
  getCsvFiles() {
    return dropboxStore;
  }
});

Dispatcher.register((payload) => {
  let action = payload.action;

  switch(action.type) {
    case 'update_list_of_csv_files':
      dropboxStore = dropboxStore.set('fileNames', action.data);
      return ExDropboxStore.emitChange();
  }

});

export default ExDropboxStore;