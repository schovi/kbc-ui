export default function(mapping) {
  if (mapping.has('columns') && mapping.get('columns').count() > 0) {
    return true;
  }

  if (mapping.get('where_column')) {
    return true;
  }

  if (mapping.get('days') > 0) {
    return true;
  }

  if (mapping.has('where_values') && mapping.get('where_values').size > 0) {
    return true;
  }
  return false;
}
