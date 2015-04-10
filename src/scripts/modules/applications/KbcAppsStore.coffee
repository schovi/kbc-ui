Immutable = require('immutable')
{Map, List} = Immutable

_store = Immutable.fromJS(
  [
    id: 'tagging'
    name: 'Tagging'
    description: 'Describe your data with predefined or custom tags'
    ui: 'kbc.docToolTagging'
  ,
    id: 'recipes'
    name: 'Recipes'
    description: 'Create predefined transformations or run analysis on your data'
    ui: 'kbc.docToolRecipes'
  ]
)

KbcAppsStore =
  getKbcApps: ->
    _store



module.exports = KbcAppsStore
