import VersionsActionCreators from '../modules/components/VersionsActionCreators';
import InstalledComponentsActionCreators from '../modules/components/InstalledComponentsActionCreators';
import TransformationActionCreators from '../modules/transformations/ActionCreators';

export default function(componentId, configId, versionId) {
  return function() {
    var reloadCallback = function(component, config) {
      var promises = [];
      if (component === 'transformation') {
        promises.push(TransformationActionCreators.loadTransformationsForce(config));
      } else {
        promises.push(InstalledComponentsActionCreators.loadComponentConfigDataForce(component, config));
      }
      return promises;
    };
    VersionsActionCreators.rollbackVersion(componentId, configId, versionId, reloadCallback);
  };
}
