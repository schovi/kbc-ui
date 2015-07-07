RoutesStore = require '../../../stores/RoutesStore'
ComponentsStore = require '../stores/ComponentsStore'

COMPONENTS_WITHOUT_API = ['wr-dropbox', 'tde-exporter', 'geneea-topic-detection',
'geneea-language-detection', 'geneea-lemmatization', 'geneea-sentiment-analysis', 'geneea-text-correction',\
 'geneea-entity-recognition']


module.exports = (componentId) ->
  componentId not in COMPONENTS_WITHOUT_API
