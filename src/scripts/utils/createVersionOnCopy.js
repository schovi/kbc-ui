import VersionsActionCreators from '../modules/components/VersionsActionCreators';
import InstalledComponentsActionCreators from '../modules/components/InstalledComponentsActionCreators';
import TransformationActionCreators from '../modules/transformations/ActionCreators';

export default function(componentId, configId, version, name) {
  return function() {
    var reloadCallback = function(component) {
      if (component === 'transformation') {
        TransformationActionCreators.loadTransformationBucketsForce();
      }
      InstalledComponentsActionCreators.loadComponentsForce();
    };
    VersionsActionCreators.copyVersion(componentId, configId, version, name, reloadCallback);
  };
}
