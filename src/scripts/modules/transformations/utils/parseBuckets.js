import parseBucket from './parseBucket';

export default function(buckets) {
  var response = [];
  if (buckets) {
    for (var i = 0; i < buckets.length; i++) {
      response[i] = parseBucket(buckets[i]);
    }
  }
  return response;
}
