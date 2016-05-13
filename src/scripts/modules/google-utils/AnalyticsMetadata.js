// import metadata from 'javascript-api-utils/lib/metadata';
import request from '../../utils/request';

const getMetadataUrl = 'https://content.googleapis.com/analytics/v3/metadata/ga/columns?reportType=ga';

function getMetadata() {
  return request('GET', getMetadataUrl)
    .promise()
    .then((response) => response.body);
}

function prepareMetadata(data) {
  return {
    metrics: data.items.filter((i) => i.attributes.type === 'METRIC'),
    dimensions: data.items.filter((i) => i.attributes.type === 'DIMENSIONS')
  };
}

export function loadMetadata() {
  return getMetadata().then((data) => {
    return prepareMetadata(data);
    // return {
    //   metrics: m.allMetrics(),
    //   dimensions: m.allDimensions()
    // };
  });
}
