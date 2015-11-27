export default function(tasks, configurations) {
  return tasks.map((task) => {
    const configId = task.getIn(['actionParameters', 'config'], task.getIn(['actionParameters', 'configBucketId'])),
      componentId = task.get('component'),
      config = configurations.getIn([componentId, 'configurations', configId]);

    return config ? task.set('config', config) : task.remove('config');
  });
}