import React, {PropTypes} from 'react/addons';
/* import ConfigurationRow from './ConfigurationRow'; */
import ComponentIcon from '../../../../react/common/ComponentIcon';
import ComponentDetailLink from '../../../../react/common/ComponentDetailLink';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    component: PropTypes.object.isRequired,
    deletingConfigurations: PropTypes.object.isRequired
  },

  render() {
    return (
      <div>
        <div className="kbc-header">
          <div className="kbc-title">
            <h2>
              <ComponentIcon component={this.props.component} size="32" />
              <ComponentDetailLink type={ this.props.component.get('type') } componentId={ this.props.component.get('id') }>
                {this.props.component.get('name')}
              </ComponentDetailLink>
            </h2>
          </div>
        </div>
        <div className="table table-hover">
          <span className="tbody">
            {this.configurations()}
          </span>
        </div>
      </div>
    );
  },

  configurations() {
    return '';
    /* return this.props.component.get('configurations').map((configuration) => {
       return React.createElement(ConfigurationRow, {
       config: configuration,
       componentId: this.props.component.get('id'),
       isDeleting: this.props.deletingConfigurations.has(configuration.get('id')),
       key: configuration.get('id')
       });
       }, this); */
  }
});
