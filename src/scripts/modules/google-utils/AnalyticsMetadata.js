import metadata from 'javascript-api-utils/lib/metadata';


export function loadMetadata() {
  return metadata.get().then((m) => {
    console.log('METADATA', m.allMetrics());
    return m.allMetrics();
  });
}
