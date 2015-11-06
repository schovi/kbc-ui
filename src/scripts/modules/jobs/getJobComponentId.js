/**
 * Returns componentId from job
 * First checks for component in params (docker and ex-generic uses this) then fallbacks to component attribute
 * @param {Object} job Job
 * @return {string} Component Id
 */
export default function(job) {
  return job.getIn(['params', 'component'], job.get('component'));
}