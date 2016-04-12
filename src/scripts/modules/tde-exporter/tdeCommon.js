export function getTdeFileName(configData, tableId) {
  const name = configData.getIn(['parameters', 'tables', tableId, 'tdename']);
  return name || `${tableId}.tde`;
}

export function getEditingTdeFileName(configData, localState, tableId) {
  const defaultName = getTdeFileName(configData, tableId);
  const editing = localState.getIn(['editingTdeNames', tableId]);
  return editing || defaultName;
}

export function assertTdeFileName(name) {
  // check for 150 len
  if (name.length > 150) {
    return 'Must be less than 150 characters long';
  }
  // check for regex(copied from backend)
  const REGEX = new RegExp('^[a-zA-Z_0-9\- \(\)\.]+$');
  if (REGEX.test(name) === false) {
    return 'Can only contain alphanumeric characters, space, dot, ( ) - _';
  }
  // check for tde extension
  if (name.endsWith('.tde') === false) {
    return 'Must end with proper extension, ie .tde';
  }
  return null;
}
