export default function(rowConfig) {
  var transformationConfig = rowConfig.configuration;

  // propagate id
  if (!transformationConfig.id) {
    transformationConfig.id = rowConfig.id;
  }

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
  return transformationConfig;
}
