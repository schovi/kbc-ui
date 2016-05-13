import string from '../../utils/string';

export function getDefaultBucket(componentId, configId) {
  const stage = 'in';
  const componentIdSanitized = componentId.replace(/[^a-zA-Z0-9-]/ig, '-');
  return stage +
    '.c-' +
    componentIdSanitized +
    '-' +
    configId;
}

export function sanitizeTableName(name) {
  return string.sanitizeKbcTableIdString(name || '');
}
