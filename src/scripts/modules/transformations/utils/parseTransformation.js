export default function(rowConfig) {
  var transformationConfig = rowConfig.configuration;

  // force propagate id
  transformationConfig.id = rowConfig.id;

  // inject missing defaults
  if (!transformationConfig.phase) {
    transformationConfig.phase = 1;
  }
  if (!transformationConfig.queries) {
    transformationConfig.queries = [];
  }
  if (!transformationConfig.requires) {
    transformationConfig.requires = [];
  }
  if (!transformationConfig.input) {
    transformationConfig.input = [];
  }
  if (!transformationConfig.output) {
    transformationConfig.output = [];
  }
  if (!transformationConfig.packages) {
    transformationConfig.packages = [];
  }
  if (transformationConfig.input.length > 0) {
    for (var key in transformationConfig.input) {
      if (Array.isArray(transformationConfig.input[key].datatypes)) {
        transformationConfig.input[key].datatypes = {};
      }
    }
  }
  if (!transformationConfig.disabled) {
    transformationConfig.disabled = false;
  }
  if (transformationConfig.disabled === '0') {
    transformationConfig.disabled = false;
  }
  if (transformationConfig.disabled === '1') {
    transformationConfig.disabled = true;
  }
  return transformationConfig;
}
