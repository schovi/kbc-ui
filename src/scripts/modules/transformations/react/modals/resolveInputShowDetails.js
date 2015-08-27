/**
 * Mysql advanced columns
 * @param mapping
 * @returns {boolean}
 */
function mysql(mapping) {
  if (mapping.has('columns') && mapping.get('columns').count() > 0) {
    return true;
  }

  if (mapping.has('datatypes') && mapping.get('datatypes').size > 0) {
    return true;
  }

  if (mapping.has('indexes') && mapping.get('indexes').size > 0) {
    return true;
  }

  if (mapping.get('optional')) {
    return true;
  }

  if (mapping.get('persistent')) {
    return true;
  }

  if (mapping.get('whereColumn')) {
    return true;
  }

  if (mapping.get('days') > 0) {
    return true;
  }

  if (mapping.has('whereValues') && mapping.get('whereValues').size > 0) {
    return true;
  }
  return false;
}

/**
 * Redshift advanced columns
 * @returns {boolean}
 */
function redshift(mapping) {
  if (mapping.has('columns') && mapping.get('columns').count() > 0) {
    return true;
  }

  if (mapping.has('datatypes') && mapping.get('datatypes').size > 0) {
    return true;
  }

  if (mapping.get('days') > 0) {
    return true;
  }

  if (mapping.get('distKey')) {
    return true;
  }

  if (mapping.has('indexes') && mapping.get('indexes').size > 0) {
    return true;
  }

  if (mapping.get('optional')) {
    return true;
  }

  if (mapping.get('persistent')) {
    return true;
  }

  if (mapping.get('sortKey')) {
    return true;
  }

  if (mapping.get('whereColumn')) {
    return true;
  }

  if (mapping.has('whereValues') && mapping.get('whereValues').size > 0) {
    return true;
  }
  return false;
}

/**
 * Docker advanced columns
 * @returns {boolean}
 */
function docker(mapping) {
  return mysql(mapping);
}

export default function(backend, type, mapping) {
  if (backend === 'mysql' && type === 'simple') {
    return mysql(mapping);
  } else if (backend === 'redshift' && type === 'simple') {
    return redshift(mapping);
  } else if (backend === 'docker' && type === 'r') {
    return docker(mapping);
  } else {
    return false;
  }
}