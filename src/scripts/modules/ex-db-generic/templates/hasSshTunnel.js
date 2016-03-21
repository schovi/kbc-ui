// by default all components have ssh tunnel, if some component dont
// put it here:
const componentsNotWithSsh = [
];

export default function(componentId) {
  !(componentsNotWithSsh.indexOf(componentId) >= 0);
}
