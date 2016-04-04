import VersionsActionCreators from '../modules/components/VersionsActionCreators';
import InstalledComponentsActionCreators from '../modules/components/InstalledComponentsActionCreators';
import TransformationActionCreators from '../modules/transformations/ActionCreators';

export default function(componentId, configId, version, name) {
  return function() {
    var reloadCallback = function(component) {
      var promises = [];
      if (component === 'transformation') {
        promises.push(TransformationActionCreators.loadTransformationBucketsForce());
      }
      promises.push(InstalledComponentsActionCreators.loadComponentsForce());
      return promises;
    };
    VersionsActionCreators.copyVersion(componentId, configId, version, name, reloadCallback);
  };
}
