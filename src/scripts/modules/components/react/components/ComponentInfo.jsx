import React from 'react';
import FormHeader from '../pages/new-component-form/FormHeader';
import VendorInfo from '../pages/component-detail/VendorInfo';
import AppUsageInfo from '../pages/new-component-form/AppUsageInfo';
import ComponentDescription from '../pages/component-detail/ComponentDescription';
import ReadMore from '../../../../react/common/ReadMore';

export default React.createClass({
  propTypes: {
    children: React.PropTypes.node,
    component: React.PropTypes.object.isRequired
  },
  render() {
    return (
      <div className="container-fluid">
        <FormHeader
          component={this.props.component}
          withButtons={false}
          />
        <div className="row">
          <div className="col-md-6">
            <VendorInfo
              component={this.props.component}
              />
            <AppUsageInfo
              component={this.props.component}
              />
          </div>
          <div className="col-md-6">
            <ReadMore>
              <ComponentDescription
                component={this.props.component}
                />
            </ReadMore>
          </div>
        </div>
        {this.props.children}
      </div>
    );
  }
});
