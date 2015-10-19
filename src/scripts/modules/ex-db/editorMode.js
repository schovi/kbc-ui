

export default function(driver) {
  switch (driver) {
    case 'mysql':
      return 'text/x-mysql';
    case 'mssql':
      return 'text/x-mssql';
    case 'pgsql':
      return 'text/x-sql';
    case 'oracle':
      return 'text/x-plsql';
    default:
      return 'text/x-mysql';
  }
}