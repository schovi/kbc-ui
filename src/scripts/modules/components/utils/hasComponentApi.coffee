RoutesStore = require '../../../stores/RoutesStore'
ComponentsStore = require '../stores/ComponentsStore'

COMPONENTS_WITHOUT_API = ['tde-exporter', 'geneea-topic-detection',
'geneea-language-detection', 'geneea-lemmatization', 'geneea-sentiment-analysis', 'geneea-text-correction']


module.exports = (componentId) ->
  componentId not in COMPONENTS_WITHOUT_API
