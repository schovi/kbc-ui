process.env.NODE_ENV = 'test';
process.env.TZ = 'UTC';

const jest = require('jest');
const argv = process.argv.slice(2);

// NOTE: temporary fix for enable console.log on localhost.
if (process.env.CI === 'true') {
  argv.push('--forceExit');
}

if (process.env.DEV_CACHE !== 'true') {
  argv.push('--no-cache');
}

jest.run(argv);
