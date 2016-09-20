import React from 'react';
import {Link} from 'react-router';
import {Routes} from '../../Constants';
import RoutesStore from '../../../../stores/RoutesStore';
import ComponentsStore from '../../stores/ComponentsStore';
const {GENERIC_DETAIL_PREFIX} = Routes;

export default React.createClass({

  propTypes: {
    componentId: React.PropTypes.string.isRequired,
    configId: React.PropTypes.string.isRequired
  },

  render() {
    return (
      <span>
        Configuration copied,&nbsp;
        {this.renderLink()}
      </span>
    );
  },

  renderLink() {
    const {componentId, configId} = this.props;
    // transformation component
    if (componentId === 'transformation') {
      return (
        <Link
          to="transformationBucket"
          params={{config: configId}}
        >
          go to the new configuration.
        </Link>
      );
    }
    // typical component route
    if (RoutesStore.hasRoute(componentId)) {
      return (
        <Link
          to={componentId}
          params={{config: configId}}
        >
          go to the new configuration.
        </Link>

      );
    }
    const components = ComponentsStore.getAll();
    // generic component route
    return (
      <Link
        to={GENERIC_DETAIL_PREFIX + components.getIn([componentId, 'type']) + '-config'}
        params={{config: configId}}
      >
        go to the new configuration.
      </Link>
    );
  }
});
