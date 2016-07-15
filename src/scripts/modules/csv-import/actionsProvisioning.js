import storeProvisioning from './storeProvisioning';
import componentsActions from '../components/InstalledComponentsActionCreators';
import storageApi from '../components/StorageApi';
import storageApiActions from '../components/StorageActionCreators';
import bucketsStore from '../components/stores/StorageBucketsStore';
import tablesStore from '../components/stores/StorageTablesStore';
import installedComponentsStore from '../components/stores/InstalledComponentsStore';

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
    const ls = installedComponentsStore.getLocalState(COMPONENT_ID, configId);
    const newLocalState = ls.setIn([].concat(path), data);
    componentsActions.updateLocalState(COMPONENT_ID, configId, newLocalState);
  }

  function getLocalState() {
    return installedComponentsStore.getLocalState(COMPONENT_ID, configId);
  }

  function startUpload() {
    var params = {
      federationToken: true,
      notify: false,
      name: getLocalState().get('file').name,
      sizeBytes: getLocalState().get('file').size
    };

    updateLocalState(['isUploading'], true);
    updateLocalState(['uploadingMessage'], 'Preparing upload');

    storageApi.prepareFileUpload(params).then(function(response) {
      var fileId = response.id;
      var s3params = {
        Key: response.uploadParams.key,
        Bucket: response.uploadParams.bucket,
        ACL: response.uploadParams.acl,
        Body: getLocalState().get('file')
      };
      var credentials = response.uploadParams.credentials;
      AWS.config.credentials = new AWS.Credentials({
        accessKeyId: credentials.AccessKeyId,
        secretAccessKey: credentials.SecretAccessKey,
        sessionToken: credentials.SessionToken
      });

      updateLocalState(['uploadingMessage'], 'Uploading to S3');

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
            updateLocalState(['uploadingMessage'], 'Creating table ' + tableId);
            var createTableParams = {
              name: tableName,
              dataFileId: fileId
            };
            storageApiActions.createTable(bucketId, createTableParams).then(function() {
              updateLocalState(['uploadingMessage'], null);
              updateLocalState(['isUploading'], false);
            });
          };

          if (!bucketsStore.hasBucket(bucketId)) {
            // create bucket and table

            updateLocalState(['uploadingMessage'], 'Creating bucket ' + bucketId);

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
              updateLocalState(['uploadingMessage'], 'Loading table ' + tableId);
              storageApiActions.loadTable(tableId, loadTableParams).then(function() {
                updateLocalState(['uploadingMessage'], null);
                updateLocalState(['isUploading'], false);
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
