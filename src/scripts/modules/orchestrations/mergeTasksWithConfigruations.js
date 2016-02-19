function mapTaskFn(task, configurations) {
  const configId = task.getIn(['actionParameters', 'config'],
                              task.getIn(['actionParameters', 'configBucketId'],
                                         task.getIn(['actionParameters', 'account'], '')
                                        )),
    componentId = task.get('component'),
    config = configurations.getIn([componentId, 'configurations', configId.toString()]);
  return config ? task.set('config', config) : task.remove('config');
}

export default function(tasks, configurations, isTasksDephased) {
  if (isTasksDephased) {
    return tasks.map((task) => mapTaskFn(task, configurations));
  } else {
    return tasks.map( (phase) => {
      const tasksWithConfig = phase.get('tasks').map((task) => {
        return mapTaskFn(task, configurations);
      });
      return phase.set('tasks', tasksWithConfig);
    });
  }
}
