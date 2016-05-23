import React from 'react';

import ApplicationStore from '../../../../stores/ApplicationStore';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';
import EmptyState from './ComponentEmptyState';
import Confirm from '../../../../react/common/Confirm';
import {Alert} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';

const MIGRATION_COMPONENT_ID = 'keboola.config-migration-tool';
const MIGRATION_ALLOWED_FEATURE = 'components-migration';

export default React.createClass({
  propTypes: {
    componentId: React.PropTypes.string.isRequired
  },

  getInitialState() {
    return {isLoading: false};
  },

  /* getDefaultProps() {
   *  return {
   *    buttonType: 'danger'
   *  };
   *},*/

  canMigrate() {
    return ApplicationStore.hasCurrentAdminFeature(MIGRATION_ALLOWED_FEATURE);
  },

  render() {
    if (!this.canMigrate()) {
      return null;
    }
    const confirmText = (
      <span>
        This will initiate a migration procces which can be then tracked in the jobs section. Nothing will be removed and the current configurations will remain untouched.
      </span>
    );
    return (
      <div className="row kbc-header">
        <EmptyState>
          <Alert bsStyle="warning">
            <span>
              This is a deprecated component, we have prepared new  components,
              click on the button and initiate a migration process
              of all configurations to the new component of database extractor                          </span>
            <div>
              <Confirm
                text={confirmText}
                buttonType="success"
                buttonLabel="Migrate"
                onConfirm={this.onMigrate}
                title="Migration Configuration">
                <button
                  type="button"
                  disabled={this.state.isLoading}
                  type="sumbit" className="btn btn-success">
                  Migrate
                  {this.state.isLoading ? <Loader/> : null}
                </button>

              </Confirm>
            </div>
          </Alert>
        </EmptyState>
      </div>
    );
  },

  onMigrate() {
    this.setState({isLoading: true});
    const params = {
      method: 'run',
      component: MIGRATION_COMPONENT_ID,
      data: {
        configData: {
          parameters: {
            component: this.props.componentId
          }
        }
      },
      notify: true
    };

    InstalledComponentsActionCreators
    .runComponent(params)
    .then(this.handleStarted)
    .catch((error) => {
      this.setState({isLoading: false});
      throw error;
    });
  },

  handleStarted() {
    this.setState({isLoading: false});
  }

});
