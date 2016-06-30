import dispatcher from '../../Dispatcher';
import Promise from 'bluebird';
import Store from './stores/VersionsStore';
import Api from './InstalledComponentsApi';
import Constants from './VersionsConstants';
import ApplicationActionCreators from '../../actions/ApplicationActionCreators';
import React from 'react';
import ConfigurationCopiedNotification from './react/components/ConfigurationCopiedNotification';

module.exports = {
  loadVersions: function(componentId, configId) {
    if (Store.hasVersions(componentId, configId)) {
      return Promise.resolve();
    }
    return this.loadVersionsForce(componentId, configId);
  },

  loadVersionsForce: function(componentId, configId) {
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      type: Constants.ActionTypes.VERSIONS_LOAD_START
    });
    return Api.getComponentConfigVersions(componentId, configId).then(function(result) {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        type: Constants.ActionTypes.VERSIONS_LOAD_SUCCESS,
        versions: result
      });
      return result;
    }).catch(function(error) {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        type: Constants.ActionTypes.VERSIONS_LOAD_ERROR
      });
      throw error;
    });
  },

  loadComponentConfigByVersion(componentId, configId, version) {
    if (Store.hasConfigByVersion(componentId, configId, version)) {
      return Promise.resolve(Store.getConfigByVersion(componentId, configId, version));
    }
    return this.loadComponentByVersionForce(componentId, configId, version);
  },

  loadComponentConfigByVersionForce(componentId, configId, version) {
    this.pendingStart(componentId, configId, version, 'config');
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      version: version,
      type: Constants.ActionTypes.VERSIONS_CONFIG_LOAD_START
    });
    return Api.getComponentConfigByVersion(componentId, configId, version).then((result) => {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        version: version,
        data: result,
        type: Constants.ActionTypes.VERSIONS_CONFIG_LOAD_SUCCESS
      });
      self.pendingStop(componentId, configId);
      return Store.getConfigByVersion(componentId, configId, version);
    }).catch((error) => {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        version: version,
        type: Constants.ActionTypes.VERSIONS_CONFIG_LOAD_ERROR
      });
      throw error;
    });
  },

  rollbackVersion: function(componentId, configId, version, reloadCallback) {
    var self = this;
    // start spinners
    this.pendingStart(componentId, configId, version, 'rollback');
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      version: version,
      type: Constants.ActionTypes.VERSIONS_ROLLBACK_START
    });
    return Api.rollbackVersion(componentId, configId, version).then(function(result) {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        version: version,
        type: Constants.ActionTypes.VERSIONS_ROLLBACK_SUCCESS
      });
      // reload versions, not required after sapi update
      var promises = [];
      promises.push(self.loadVersionsForce(componentId, configId));
      // reload configs!
      promises.push(...reloadCallback(componentId, configId));
      Promise.all(promises).then(function() {
        // stop spinners
        self.pendingStop(componentId, configId);
        // notification
        ApplicationActionCreators.sendNotification({
          message: 'Configuration rollback successful'
        });
      }).catch(function(error) {
        throw error;
      });
      return result;
    }).catch(function(error) {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        version: version,
        type: Constants.ActionTypes.VERSIONS_ROLLBACK_ERROR
      });
      throw error;
    });
  },

  copyVersion: function(componentId, configId, version, name, reloadCallback) {
    var self = this;
    // start spinners
    this.pendingStart(componentId, configId, version, 'copy');
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      version: version,
      name: name,
      type: Constants.ActionTypes.VERSIONS_COPY_START
    });
    return Api.createConfigCopy(componentId, configId, version, name).then(function(result) {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        version: version,
        name: name,
        type: Constants.ActionTypes.VERSIONS_COPY_SUCCESS
      });

      var promises = [];
      // reload versions, not required after sapi update
      promises.push(self.loadVersionsForce(componentId, configId));

      // reload configs!
      promises.push(...reloadCallback(componentId));

      Promise.all(promises).then(function() {
        // stop spinners
        self.pendingStop(componentId, configId);
        // send notification
        ApplicationActionCreators.sendNotification({
          message: React.createClass({
            render() {
              return React.createElement(ConfigurationCopiedNotification, {
                componentId: componentId,
                configId: result.id
              });
            }
          })
        });
      }).catch(function(error) {
        throw error;
      });
      return result;
    }).catch(function(error) {
      dispatcher.handleViewAction({
        componentId: componentId,
        configId: configId,
        version: version,
        name: name,
        type: Constants.ActionTypes.VERSIONS_COPY_ERROR
      });
      throw error;
    });
  },

  changeNewVersionName: function(componentId, configId, version, name) {
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      version: version,
      name: name,
      type: Constants.ActionTypes.VERSIONS_NEW_NAME_CHANGE
    });
  },

  changeFilter: function(componentId, configId, query) {
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      query: query,
      type: Constants.ActionTypes.VERSIONS_FILTER_CHANGE
    });
  },

  pendingStart: function(componentId, configId, version, action) {
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      version: version,
      action: action,
      type: Constants.ActionTypes.VERSIONS_PENDING_START
    });
  },

  pendingStop: function(componentId, configId) {
    dispatcher.handleViewAction({
      componentId: componentId,
      configId: configId,
      type: Constants.ActionTypes.VERSIONS_PENDING_STOP
    });
  }
};
