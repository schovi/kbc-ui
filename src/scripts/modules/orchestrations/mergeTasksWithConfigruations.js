export default function(tasks, configurations) {
  return tasks.map( (phase) => {
    const tasksWithConfig = phase.get('tasks').map((task) => {
      const configId = task.getIn(['actionParameters', 'config'],
                                  task.getIn(['actionParameters', 'configBucketId'],
                                             task.getIn(['actionParameters', 'account'])
                                            )),
        componentId = task.get('component'),
        config = configurations.getIn([componentId, 'configurations', configId]);

      return config ? task.set('config', config) : task.remove('config');
    });
    return phase.set('tasks', tasksWithConfig);
  });
}
