import _ from 'underscore';
import Promise from 'bluebird';

import storageApi from '../../../StorageApi';
import jobsApi from '../../../../jobs/JobsApi';
import string from '../../../../../utils/string';

const dataProfilerBucketPrefix = 'in.c-lg-rcp-data-profiler_';

export default function fetchData(tableId){
  const profilerConfigId = string.webalize(tableId);
  const jobQuery = `config:${profilerConfigId} AND recipeId:rcp-data-profiler`;

  return jobsApi.getJobsParametrized(jobQuery, 1, 0).then((jobs) =>{
    const resultsTableId = `${dataProfilerBucketPrefix}${profilerConfigId}.VAI__1`;
    // if table has analysis job than load its results
    if (!_.isEmpty(jobs)){
      return storageApi.exportTable(resultsTableId).then((data) =>{
        const analysis = {
          'job': _.first(jobs),
          'data': data
        };
        return analysis;
      });
    }
    else{
      return Promise.resolve();
    }
  });
}
