import VersionsActionCreators from '../modules/components/VersionsActionCreators';
import InstalledComponentsActionCreators from '../modules/components/InstalledComponentsActionCreators';
import TransformationActionCreators from '../modules/transformations/ActionCreators';

export default function(componentId, configId, versionId) {
  return function() {
    var reloadCallback = function(component, config) {
      if (component === 'transformation') {
        TransformationActionCreators.loadTransformationsForce(config);
      } else {
        InstalledComponentsActionCreators.loadComponentConfigDataForce(component, config);
      }
    };
    VersionsActionCreators.rollbackVersion(componentId, configId, versionId, reloadCallback);
  };
}
