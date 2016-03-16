const componentsWithSsh = [
  'keboola.ex-db-pgsql',
  'keboola.ex-db-db2',
  'keboola.ex-db-firebird'
];

export default function(componentId) {
  return componentsWithSsh.indexOf(componentId) >= 0;
}
