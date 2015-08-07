import React from 'react';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import RoutesStore from '../../../../stores/RoutesStore';
import ComponentStore from '../../stores/ComponentsStore';

import GenericDetailStatic from './GenericDetailStatic';
import GenericDockerDetail from './GenericDockerDetail';
import GenericDetailEditable from './GenericDetailEditable';

export default React.createClass({
  mixins: [createStoreMixin(ComponentStore)],

  getStateFromStores() {
    const componentId = RoutesStore.getCurrentRouteParam('component');

    return {
      component: ComponentStore.getComponent(componentId)
    };
  },

  render() {
    if (this.state.component.get('flags').includes('genericDockerUI')) {
      return (<GenericDockerDetail />);
    } else if (this.state.component.get('flags').includes('genericUI')) {
      return (<GenericDetailEditable />);
    } else {
      return (<GenericDetailStatic />);
    }
  }

});
