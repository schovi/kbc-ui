import gapi from './InitGoogleApis';

function loadSheetsApi() {
  var discoveryUrl =
      'https://sheets.googleapis.com/$discovery/rest?version=v4';
  return gapi().client.load(discoveryUrl);
}

export function listSheets(fileId) {
  return loadSheetsApi()
    .then( () =>
           gapi().client.sheets.spreadsheets.get({
             spreadsheetId: fileId
           }));
}
