import _ from 'underscore';
//import React from 'react';
import DropboxApi from '../utils/api';
import Dispatcher from '../../../Dispatcher';


export default {

  getListOfCsvFiles(token) {
    DropboxApi.getCsvFilesFromDropbox(token)
      .then((response) => {
        var files = [];

        _.map(response, (file) => {
          files.push(file.path);
        });

        return Dispatcher.handleViewAction({
          type: 'update_list_of_csv_files',
          data: files
        });
      });
  }
};