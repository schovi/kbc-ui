import _ from 'underscore';
import Promise from 'bluebird';

import storageApi from '../../../StorageApi';
import jobsApi from '../../../../jobs/JobsApi';
import string from '../../../../../utils/string';

const dataProfilerBucketPrefix = 'in.c-lg-rcp-data-profiler_';

const unwantedJobs = ['terminating', 'canceled', 'terminated', 'cancelled', 'error'];

export default function fetchData(tableId){
  const profilerConfigId = string.webalize(tableId);
  const unwantedJobsQuery = unwantedJobs.map(j => `status:${j}`).join(' OR ');
  const jobQuery = `config:${profilerConfigId} AND recipeId:rcp-data-profiler AND NOT(${unwantedJobsQuery})`;


  return jobsApi.getJobsParametrized(jobQuery, 1, 0).then((jobs) =>{
    const resultsTableId = `${dataProfilerBucketPrefix}${profilerConfigId}.VAI__1`;
    console.log('enhanced JOBS', jobs);
    // if table has analysis job than load its results
    if (!_.isEmpty(jobs)){
      const okJob = jobs.find(j => j.status === 'success');
      const runningJob = jobs.find(j => j.status !== 'success');

      return storageApi.exportTable(resultsTableId).then((data) =>{
        const analysis = {
          okJob: okJob,
          runningJob: runningJob,
          data: data
        };
        return analysis;
      }).catch( () => {
        return {
          okJob: okJob,
          runningJob: runningJob,
          data: null
        };
      });
    }
    else{
      return Promise.resolve();
    }
  });
}
