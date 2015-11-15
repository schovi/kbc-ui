import _ from 'underscore';
import DropboxApi from '../utils/api';
import Dispatcher from '../../../Dispatcher';
import { ActionTypes } from '../constants';

export default {
  getListOfCsvFiles(token) {
    DropboxApi.getCsvFilesFromDropbox(token)
      .then((response) => {
        var files = [];

        _.map(response, (file) => {
          files.push({ 'label': file.path, value: file.path });
        });

        return Dispatcher.handleViewAction({
          type: ActionTypes.UPDATE_LIST_OF_CSV_FILES,
          data: files
        });
      })
      .catch((error) => {
        throw error;
      });
  }
};