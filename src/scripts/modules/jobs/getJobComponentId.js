/**
 * Returns componentId from job
 * First checks for component in params (docker and ex-generic uses this) then fallbacks to component attribute
 * @param job
 * @returns {any|*}
 */
export default function(job) {
    return job.getIn(['params', 'component'], job.get('component'));
}