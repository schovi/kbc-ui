import React from 'react';
import {addons} from 'react/addons';
import SidebarVersionsRow from './SidebarVersionsRow';
import {Link} from 'react-router';
import './SidebarVersions.less';

module.exports = React.createClass({
  displayName: 'SidebarVersions',
  mixins: [addons.PureRenderMixin],
  propTypes: {
    versions: React.PropTypes.object.isRequired,
    isLoading: React.PropTypes.bool.isRequired,
    configId: React.PropTypes.string.isRequired,
    componentId: React.PropTypes.string.isRequired,
    limit: React.PropTypes.number,
    versionsLinkTo: React.PropTypes.string,
    versionsLinkParams: React.PropTypes.object
  },
  getDefaultProps: function() {
    return {
      limit: 5
    };
  },

  getVersionsLinkParams: function() {
    if (this.props.versionsLinkParams) {
      return this.props.versionsLinkParams;
    }
    return {
      component: this.props.componentId,
      config: this.props.configId
    };
  },

  getVersionsLinkTo: function() {
    if (this.props.versionsLinkTo) {
      return this.props.versionsLinkTo;
    }
    return this.props.componentId + '-versions';
  },

  renderVersions: function() {
    const props = this.props;
    const self = this;
    if (this.props.versions.count() || this.props.isLoading) {
      return this.props.versions.slice(0, 3).map(function(version) {
        const isLast = (version.get('version') === props.versions.first().get('version'));
        return (
          <Link
            className="list-group-item"
            to={self.getVersionsLinkTo()}
            params={self.getVersionsLinkParams()}
          >
            <SidebarVersionsRow
              version={version}
              isLast={isLast}
            />
          </Link>
            );
      }).toArray();
    } else {
      return (<div><small className="text-muted">No versions found</small></div>);
    }
  },

  renderAllVersionsLink() {
    if (this.props.versions.count() === 0) {
      return null;
    }
    return (
      <div className="versions-link">
        <Link
          to={this.getVersionsLinkTo()}
          params={this.getVersionsLinkParams()}
        >
          Show all versions
        </Link>
      </div>
    );
  },

  render: function() {
    return (
      <div>
        <h4>Last updates</h4>
        <div className="kbc-sidebar-versions">
          {this.renderVersions()}
          {this.renderAllVersionsLink()}
        </div>
      </div>
    );
  }
});
