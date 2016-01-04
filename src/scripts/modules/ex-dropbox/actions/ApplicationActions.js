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
  let destinationFile = fileName.toString().split('/');
  let file = destinationFile[destinationFile.length - 1].slice(0, -4);

  return `${file}`;
}

export function extractValues(inputArray) {
  var returnArray = [];

  inputArray.map((value) => {
    returnArray.push(value.label);
  });

  return returnArray;
}

export function sortTimestampsInDescendingOrder(obj1, obj2) {
  if (obj1.timestamp < obj2.timestamp) {
    return 1;
  } else if (obj1.timestamp > obj2.timestamp) {
    return -1;
  } else {
    return 0;
  }
}

export function sortTimestampsInAscendingOrder(obj1, obj2) {
  if (obj1.timestamp > obj2.timestamp) {
    return 1;
  } else if (obj1.timestamp < obj2.timestamp) {
    return -1;
  } else {
    return 0;
  }
}