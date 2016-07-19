import {Map} from 'immutable';

export function getPreviousVersion(allVersions, version) {
  const previousVersion = allVersions.find((v) => v.get('version') === version.get('version') - 1) || Map();
  return previousVersion;
}
