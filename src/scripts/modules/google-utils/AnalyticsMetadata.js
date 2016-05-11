import metadata from 'javascript-api-utils/lib/metadata';

export function loadMetadata() {
  return metadata.get().then((m) => {
    return {
      metrics: m.allMetrics(),
      dimensions: m.allDimensions()
    };
    // if (type === 'metrics') {
    //   // console.log('metrics', m.allMetrics());
    //   return m.allMetrics();
    // } else {
    //   return m.allDimensions();
    // }
  });
}
