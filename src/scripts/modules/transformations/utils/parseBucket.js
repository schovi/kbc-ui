import parseTransformation from './parseTransformation';

export default function(bucket) {
  bucket.transformations = bucket.rows;
  delete bucket.rows;
  if (bucket.transformations) {
    for (var i = 0; i < bucket.transformations.length; i++) {
      bucket.transformations[i] = parseTransformation(bucket.transformations[i]);
    }
  } else {
    bucket.transformations = [];
  }
  return bucket;
}
