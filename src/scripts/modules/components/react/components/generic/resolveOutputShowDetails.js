export default function(mapping) {
  if (mapping.get('delete_where_column')) {
    return true;
  }

  if (mapping.has('delete_where_values') && mapping.get('delete_where_values').size > 0) {
    return true;
  }

  if (mapping.get('incremental')) {
    return true;
  }

  if (mapping.has('primary_key') && mapping.get('primary_key').size > 0) {
    return true;
  }
  return false;
}
