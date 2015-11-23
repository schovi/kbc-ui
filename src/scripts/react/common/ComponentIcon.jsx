import React from 'react';
import classNames from 'classnames';

import ApplicationStore from '../../stores/ApplicationStore';

import extractor from '../../../images/extractor-32-1.png';
import writer from '../../../images/writer-32-1.png';
import other from '../../../images/other-32-1.png';

const DEFAULT_ICON_IMAGES = {
  extractor: extractor,
  writer: writer,
  other: other
};

function getComponentIconURL(componentType) {
  const fileName = DEFAULT_ICON_IMAGES[componentType] ? DEFAULT_ICON_IMAGES[componentType] : DEFAULT_ICON_IMAGES.other;
  return ApplicationStore.getScriptsBasePath() + fileName;
}

export default React.createClass({
  propTypes: {
    component: React.PropTypes.object,
    size: React.PropTypes.string,
    className: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      size: '32'
    };
  },

  is3rdParty() {
    var component = this.props.component;
    if (!component) {
      return false;
    }
    return !!this.props.component.get('flags').contains('3rdParty');
  },

  get3rdPartyIcon() {
    if (this.is3rdParty()) {
      if (this.props.size === 32) {
        return (
          <a href="https://github.com/keboola/docker-bundle/blob/master/3RDPARTY.md">
            <i className="fa fa-cloud kbcComponentIcon-3rdParty-32px" title="3rd party application"></i>
          </a>
        );
      }
      if (this.props.size === 64) {
        return (
          <a href="https://github.com/keboola/docker-bundle/blob/master/3RDPARTY.md">
            <i className="fa fa-cloud kbcComponentIcon-3rdParty-64px" title="3rd party application"></i>
          </a>
        );
      }
    } else {
      return null;
    }
  },

  render() {
    const component = this.props.component;
    if (!component) {
      return this.emptyIcon();
    }
    return component.get('ico' + this.props.size) ?
      this.imageIcon(this.props.component.get('ico' + this.props.size)) :
      this.imageIcon(getComponentIconURL(this.props.component.get('type')));
  },

  emptyIcon() {
    return (
      <span/>
    );
  },

  imageIcon(url) {
    return (
      <span className={classNames('kb-sapi-component-icon', this.props.className)}>
        <img src={ url } />
        { this.get3rdPartyIcon() }
      </span>
    );
  }

});
