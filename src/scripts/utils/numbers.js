import numeral from 'numeral';

export function bytesToGBFormatted(bytes) {
  const gb = bytes / (1000 * 1000 * 1000);
  return numeral(gb).format('0.00');
}

export function numericMetricFormatted(value) {
  return numeral(value).format('0,00');
}