import React from 'react';
import classNames from 'classnames';

const DEFAULT_ICON_CLASS = {
  extractor: 'fa-cloud-download',
  writer: 'fa-cloud-upload',
  transformation: 'fa-cogs',
  recipe: 'fa-cogs',
  other: 'fa-cogs'
};

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
    return component.get('ico' + this.props.size) ? this.imageIcon() : this.fontIcon();
  },

  emptyIcon() {
    return (
      <span/>
    );
  },

  fontIcon() {
    const iconStyle = {
      'font-size': (this.props.size - 5) + 'px',
      height: this.props.size + 'px',
      position: 'relative',
      top: '5px'
    };
    return (
      <span className={classNames('kb-sapi-component-icon', this.props.className)}>
        <span className="kb-default">
          <i className={classNames('fa', DEFAULT_ICON_CLASS[this.props.component.get('type')])}
            style={iconStyle}
            />
        </span>
      </span>
    );
  },

  imageIcon() {
    return (
      <span className={classNames('kb-sapi-component-icon', this.props.className)}>
        <img src={this.props.component.get('ico' + this.props.size)} />
      </span>
    );
  }

});