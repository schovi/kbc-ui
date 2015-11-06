import _ from 'underscore';
import Promise from 'bluebird';

import InstalledComponentsActionCreators from '../../../InstalledComponentsActionCreators';

import storageApi from '../../../StorageApi';
import jobsApi from '../../../../jobs/JobsApi';
import string from '../../../../../utils/string';

const dataProfilerBucketPrefix = 'in.c-lg-rcp-data-profiler_';

const unwantedJobs = ['terminating', 'canceled', 'terminated', 'cancelled', 'error'];

export function getDataProfilerJob(jobId) {
  return jobsApi.getJobDetail(jobId);
}

export function startDataProfilerJob(tableId) {
  const profilerConfigId = string.webalize(tableId);
  const params = {
    component: 'rcp-data-profiler',
    method: 'run',
    notify: false,
    data: {
      config: profilerConfigId,
      configData: {
        datatable: tableId
      }
    }
  };
  return InstalledComponentsActionCreators.runComponent(params);
}

export function fetchProfilerData(tableId) {
  const profilerConfigId = string.webalize(tableId);
  const unwantedJobsQuery = unwantedJobs.map(j => `status:${j}`).join(' OR ');
  const jobQuery = `config:${profilerConfigId} AND recipeId:rcp-data-profiler AND NOT(${unwantedJobsQuery})`;

  return jobsApi.getJobsParametrized(jobQuery, 10, 0).then((jobs) =>{
    const resultsTableId = `${dataProfilerBucketPrefix}${profilerConfigId}.VAI__1`;

    // if table has analysis job than load its results
    if (!_.isEmpty(jobs)) {
      const okJob = _.find(jobs, j => j.status === 'success');
      const runningJob = _.find(jobs, j => j.status !== 'success');

      return storageApi.exportTable(resultsTableId).then((data) =>{
        const analysis = {
          okJob: okJob,
          runningJob: runningJob,
          data: data
        };
        return analysis;
      }).catch( () => {
        return {
          okJob: null,
          runningJob: runningJob,
          data: null
        };
      });
    } else {
      return Promise.resolve();
    }
  });
}
