const componentsWithSsh = [
  'keboola.ex-db-pgsql'
];

export default function(componentId) {
  return componentsWithSsh.indexOf(componentId) >= 0;
}
