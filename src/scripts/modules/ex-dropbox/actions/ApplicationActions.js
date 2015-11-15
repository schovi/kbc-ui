export function getBucketsForSelection(buckets) {
  return buckets.map((bucketName) => {
    return { value: bucketName, label: bucketName };
  });
}

export function filterBuckets(buckets) {
  let inputBuckets = buckets.filter((bucket) => {
    return bucket.get('stage') === 'in';
  });

  return inputBuckets;
}

export function listBucketNames(buckets) {
  var bucketNameList = [];

  buckets.map((bucketObject, bucketId) => {
    bucketNameList.push(bucketId);
  });

  return bucketNameList;
}

export function getDestinationName(fileName) {
  let destinationFile = fileName.toString().replace(/\/| /g, '_').toLowerCase().slice(1, -4);

  return `${destinationFile}`;
}

export function extractValues(inputArray) {
  var returnArray = [];

  inputArray.map((value) => {
    returnArray.push(value.label);
  });

  return returnArray;
}