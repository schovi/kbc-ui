import numeral from 'numeral';

export function bytesToGBFormatted(bytes) {
  const gb = bytes / (1000 * 1000 * 1000);
  const format = Math.trunc(gb) === gb ? '0' : '0.00';
  return numeral(gb).format(format);
}

function convert(value, unit) {
  if (unit === 'millions') {
    return value / 1000000;
  }
  return value;
}

export function numericMetricFormatted(value, unit = null) {
  const finalUnit = (unit === 'millions' && value < 1000000) ? 'number' : unit;
  const formatted = numeral(convert(value, finalUnit)).format('0,00');
  if (finalUnit === 'millions') {
    return formatted + ' M';
  }
  return formatted;
}