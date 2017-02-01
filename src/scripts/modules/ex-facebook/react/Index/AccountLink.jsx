import React, {PropTypes} from 'react';

export default React.createClass({

  propTypes: {
    account: PropTypes.object.isRequired,
    componentId: PropTypes.string.isRequired
  },

  render() {
    if (this.props.componentId === 'keboola.ex-facebook') return this.renderFbPageLink();
    if (this.props.componentId === 'keboola.ex-facebook-ads') return this.renderFbAdAccountLink();

    return 'Unknown component ' + this.props.componentId;
  },

  renderFbPageLink() {
    const {account} = this.props;
    const pageId = account.get('id');
    const pageName = account.get('name');

    if (pageId) {
      return (
        <a target="_blank" href={`https://www.facebook.com/${pageId}`}>
          {pageName || pageId}
        </a>);
    }
    if (pageName) return pageName;
    return 'Unknown page';
  },

  renderFbAdAccountLink() {
    const {account} = this.props;
    const id = account.get('id');
    const accountId = account.get('account_id');
    const accountName = account.get('name');
    const businessName = account.get('business_name');

    if (accountId) {
      return (
        <a target="_blank"
          href={`https://www.facebook.com/ads/manager/account/campaigns/?act=${accountId}`}>
          {accountName || businessName || accountId}
        </a>);
    }
    if (accountName || businessName || id) return accountName || businessName || id;
    return 'Unknown Ad Account';
  }
});
