import storeProvisioning from './storeProvisioning';
import componentsActions from '../components/InstalledComponentsActionCreators';
import storageApi from '../components/StorageApi';
import storageApiActions from '../components/StorageActionCreators';
import bucketsStore from '../components/stores/StorageBucketsStore';
import tablesStore from '../components/stores/StorageTablesStore';

// via https://github.com/aws/aws-sdk-js/issues/603#issuecomment-228233113
import 'aws-sdk/dist/aws-sdk';
const AWS = window.AWS;

const COMPONENT_ID = 'keboola.csv-import';

// PROPTYPES HELPER:
/*
  localState: PropTypes.object.isRequired,
  updateLocalState: PropTypes.func.isRequired,
*/

export default function(configId) {
  const store = storeProvisioning(configId);

  function updateLocalState(path, data) {
    const ls = store.getLocalState();
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(COMPONENT_ID, configId, newLocalState);
  }

  function startUpload() {
    var params = {
      federationToken: true,
      notify: false,
      name: store.getLocalState().get('file').name,
      sizeBytes: store.getLocalState().get('file').size
    };

    storageApi.prepareFileUpload(params).then(function(response) {
      var fileId = response.id;
      var s3params = {
        Key: response.uploadParams.key,
        Bucket: response.uploadParams.bucket,
        ACL: response.uploadParams.acl,
        Body: store.getLocalState().get('file')
      };
      var credentials = response.uploadParams.credentials;
      AWS.config.credentials = new AWS.Credentials({
        accessKeyId: credentials.AccessKeyId,
        secretAccessKey: credentials.SecretAccessKey,
        sessionToken: credentials.SessionToken
      });
      new AWS.S3().putObject(s3params, function(err, data) {
        if (err) {
          // todo chyba
          console.log(err, data);
          throw err;
        } else {
          var tableId = store.destination;
          var bucketId = tableId.substr(0, tableId.lastIndexOf('.'));
          var tableName = tableId.substr(tableId.lastIndexOf('.') + 1);

          var createTable = function() {
            console.log('create table');
            var createTableParams = {
              name: tableName,
              dataFileId: fileId
            };
            storageApiActions.createTable(bucketId, createTableParams).then(function() {
              console.log('table created');
            });
          };

          if (!bucketsStore.hasBucket(bucketId)) {
            // create bucket and table
            var createBucketParams = {
              name: bucketId.substr(bucketId.indexOf('-') + 1),
              stage: bucketId.substr(0, bucketId.lastIndexOf('.'))
            };
            storageApiActions.createBucket(createBucketParams)
              .then(createTable);
          } else {
            // does table exist? load or create
            if (tablesStore.hasTable(tableId)) {
              var loadTableParams = {
                dataFileId: fileId
              };
              storageApiActions.loadTable(tableId, loadTableParams).then(function() {
                console.log('hotovka');
              });
            } else {
              createTable();
            }
          }
        }
      });
    });
  }

  return {
    updateLocalState,
    startUpload
  };
}
