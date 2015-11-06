// CodeMirror, copyright (c) by Marijn Haverbeke and others
// Distributed under an MIT license: http://codemirror.net/LICENSE

// Depends on jsonlint.js from https://github.com/zaach/jsonlint

/* eslint no-empty:0 */
/* eslint new-cap:0 */

import CodeMirror from 'codemirror';
import parser from './parser';

CodeMirror.registerHelper('lint', 'json', function(text) {
  var found = [];
  parser.parser.parseError = function(str, hash) {
    var loc = hash.loc;
    found.push({from: CodeMirror.Pos(loc.first_line - 1, loc.first_column),
      to: CodeMirror.Pos(loc.last_line - 1, loc.last_column),
      message: str});
  };
  try {
    parser.parse(text);
  } catch (e) {
    // Do nothing
  }
  return found;
});
