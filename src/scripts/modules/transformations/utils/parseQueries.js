import {List} from 'immutable';

/**
 * taken and modified from
 * http://stackoverflow.com/questions/4747808/split-mysql-queries-in-array-each-queries-separated-by/5610067#5610067
 * @param queries
 */
function splitSqlQueries(queries) {
  const regex = '\s*((?:\'[^\'\\\\]*(?:\\\\.[^\'\\\\]*)*\'|' +
      '"[^"\\\\]*(?:\\\\.[^"\\\\]*)*"|\#.*|\\/\\*[\\w\\W]*?(?=\\*\\/)\\*\\/|--.*|[^"\';#])+(?:;|$))',
    re = new RegExp(regex, 'g');

  return List(queries.match(re))
    .filter((line) => line.trim() !== '')
    .map((line) => line.trim());
}

export default function(transformation, queries) {
  if (['redshift', 'mysql', 'snowflake'].indexOf(transformation.get('backend')) >= 0) {
    return splitSqlQueries(queries);
  } else {
    return List([queries]);
  }
}
