/* eslint-disable no-console,no-process-exit */
process.env.NODE_ENV = 'test';

const path = require('path');
const findCacheDir = require('find-cache-dir');
const { CLIEngine } = require('eslint');

const argv = process.argv.slice(2);

const DEFAULT_FILES_TO_LINT = [
  path.join(process.cwd(), '{environment,src/scripts}/**/*.{js,jsx}')
];

// Manual for eslint node api there http://eslint.org/docs/developer-guide/nodejs-api
const cli = new CLIEngine({
  cache: process.env.DEV_CACHE === 'true',
  cacheLocation: findCacheDir({ name: 'eslint' }),
  color: true,
  ext: ['js', 'jsx'],
  fix: argv.includes('--fix'),
  ignorePattern: ['__snapshots__']
});

const filesFilter = argv.filter(arg => arg[0] !== '-').map(file => `**/${file}*`);
const files = (filesFilter && filesFilter.length) ? filesFilter : DEFAULT_FILES_TO_LINT;
const report = cli.executeOnFiles(files);

const formatter = cli.getFormatter('codeframe');

console.log(formatter(report.results));

if (report.errorCount > 0) {
  process.exit(1);
}
