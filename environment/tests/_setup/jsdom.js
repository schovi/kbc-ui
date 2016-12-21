import jsdom from 'jsdom';

// JSDOM
const doc = jsdom.jsdom('<html><head></head><body><script></script></body></html>');
const win = doc.defaultView;

win.process = { env: process.env };

// from mocha-jsdom https://github.com/rstacruz/mocha-jsdom/blob/master/index.js#L80
function propagateProperties(source, target) {
  for (const key in source) {
    if (!source.hasOwnProperty(key)) continue;
    if (key in target) continue;

    target[key] = source[key];
  }
}

propagateProperties(win, global);

global.document = doc;
global.window = win;
global.navigator = {
  userAgent: 'node.js'
};