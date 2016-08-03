import React from 'react';
import SidebarVesions from './SidebarVersions';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import InstalledComponentStore from '../../stores/InstalledComponentsStore';
import ComponentStore from '../../stores/ComponentsStore';
import VersionsStore from '../../stores/VersionsStore';

export default React.createClass({
  displayName: 'LatestVersionsWrapper',

  mixins: [createStoreMixin(InstalledComponentStore, ComponentStore, VersionsStore, RoutesStore)],

  getStateFromStores: function() {
    const configId = RoutesStore.getCurrentRouteParam('config'),
      componentId = this.props.componentId || RoutesStore.getCurrentRouteParam('component'),
      component = ComponentStore.getComponent(componentId);

    var versionsLinkTo = null;
    var versionsLinkParams = null;

    if (component) {
      versionsLinkTo = component.get('type') + '-versions';
      versionsLinkParams = {
        component: componentId,
        config: configId
      };
    }

    return {
      versions: VersionsStore.getVersions(componentId, configId),
      componentId: componentId,
      configId: configId,
      isLoading: false,
      versionsLinkTo: versionsLinkTo,
      versionsLinkParams: versionsLinkParams
    };
  },

  propTypes: {
    limit: React.PropTypes.number,
    componentId: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      limit: 5
    };
  },

  render: function() {
    if (!this.state.versionsLinkTo) {
      return null;
    }
    return (
      <SidebarVesions
        versions={this.state.versions}
        isLoading={this.state.isLoading}
        configId={this.state.configId}
        componentId={this.state.componentId}
        versionsLinkTo={this.state.versionsLinkTo}
        versionsLinkParams={this.state.versionsLinkParams}
        limit={this.props.limit}
      />
    );
  }
});
