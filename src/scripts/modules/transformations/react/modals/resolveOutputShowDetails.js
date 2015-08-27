

export default function(mapping) {
  if (mapping.get('deleteWhereColumn')) {
    return true;
  }

  if (mapping.has('deleteWhereValues') && mapping.get('deleteWhereValues').size > 0) {
    return true;
  }

  if (mapping.get('incremental')) {
    return true;
  }

  if (mapping.has('primaryKey') && mapping.get('primaryKey').size > 0) {
    return true;
  }
  return false;
}