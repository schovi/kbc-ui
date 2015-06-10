import React from 'react';
import classNames from 'classnames';

import extractor from '../../../images/extractor-32-1.png';
import writer from '../../../images/writer-32-1.png';
import other from '../../../images/other-32-1.png';

const DEFAULT_ICON_IMAGES = {
  extractor: extractor,
  writer: writer,
  other: other
};

function getComponentIconURL(componentType) {
  return DEFAULT_ICON_IMAGES[componentType] ? DEFAULT_ICON_IMAGES[componentType] : DEFAULT_ICON_IMAGES.other;
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
      </span>
    );
  }

});