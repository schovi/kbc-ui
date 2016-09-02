
export function formatAsYearMonth(year, month) {
  return year + '-' + (month >= 10 ? month : '0' + month);
}

export function getPreviousYearMonth(yearMonth) {
  const year = parseInt(yearMonth.substr(0, 4), 10);
  const month = parseInt(yearMonth.substr(5, 2), 10);
  const previousYear = month === 1 ? year - 1 : year;
  const previousMonth = month === 1 ? 12 : month - 1;

  return formatAsYearMonth(previousYear, previousMonth);
}

export function getNextYearMonth(yearMonth) {
  const year = parseInt(yearMonth.substr(0, 4), 10);
  const month = parseInt(yearMonth.substr(5, 2), 10);
  const nextYear = month === 12 ? year + 1 : year;
  const nextMonth = month === 12 ? 1 : month + 1;

  return formatAsYearMonth(nextYear, nextMonth);
}
