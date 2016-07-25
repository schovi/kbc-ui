import React from 'react';
import RoutesStore from '../../../../stores/RoutesStore';
import TransformationBucketsStore from '../../stores/TransformationBucketsStore';
import VersionsDropdown from '../../../../react/common/VersionsDropdown';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';

export default React.createClass({
  mixins: [createStoreMixin(TransformationBucketsStore)],

  getStateFromStores() {
    return {
      bucket: TransformationBucketsStore.get(RoutesStore.getCurrentRouteParam('bucketId'))
    };
  },

  render() {
    return (
      <span>
        <VersionsDropdown firstVersionAsTitle={false} dropDownButtonSize="default"
          componentId="transformation" configIdParam="bucketId" />
      </span>
    );
  }
});
