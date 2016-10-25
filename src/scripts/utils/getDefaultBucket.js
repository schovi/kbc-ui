export default function getDefaultBucket(stage, componentId, configId) {
  const componentIdSanitized = componentId.replace(/[^a-zA-Z0-9-]/ig, '-');
  return stage +
    '.c-' +
    componentIdSanitized +
    '-' +
    configId;
}
