_ = require 'underscore'

sheets = ->
  view = new google.picker.DocsView(google.picker.ViewId.SPREADSHEETS)
  view.setIncludeFolders(true)
  view.setOwnedByMe(false)
  #view.setSelectFolderEnabled(true)
  view.setParent("root")
  return view

sharedSheets = ->
  allFoldersView = new google.picker.DocsView(google.picker.ViewId.SPREADSHEETS)
  allFoldersView.setIncludeFolders(true)
  allFoldersView.setMode(google.picker.DocsViewMode.GRID)
  #allFoldersView.setSelectFolderEnabled(true)
  return allFoldersView


module.exports =
  sheetsGroup: -> #NOT WORKING
    group = new google.picker.ViewGroup(sheets())
    group = group.addLabel('User sheets')
    group = group.addView(sharedSheets())
    group = group.addLabel('shared sheets')
    return group

  sheets: ->
    sheets()

  sharedSheets: ->
    sharedSheets()

  root: (foldersOnly) ->
    view = new google.picker.DocsView()
    view.setIncludeFolders(true)
    if foldersOnly
      view.setSelectFolderEnabled(true)
      view.setMimeTypes('application/vnd.google-apps.folder')
    view.setParent("root")
    return view

  flat: (foldersOnly) ->
    allFoldersView = new google.picker.DocsView()
    allFoldersView.setIncludeFolders(true)
    if foldersOnly
      allFoldersView.setSelectFolderEnabled(true)
      allFoldersView.setMimeTypes('application/vnd.google-apps.folder')
    return allFoldersView

  recent: (foldersOnly) ->
    recentView = new google.picker.DocsView(google.picker.ViewId.RECENTLY_PICKED)
    if foldersOnly
      recentView.setMimeTypes('application/vnd.google-apps.folder')
      recentView.setSelectFolderEnabled(true)
    recentView.setIncludeFolders(true)
    return recentView

  recentFolders: ->
    recentView = new google.picker.DocsView(google.picker.ViewId.RECENTLY_PICKED)
    recentView.setMimeTypes('application/vnd.google-apps.folder')
    recentView.setSelectFolderEnabled(true)
    recentView.setIncludeFolders(true)
    return recentView

  flatFolders: ->
    allFoldersView = new google.picker.DocsView()
    allFoldersView.setIncludeFolders(true)
    allFoldersView.setSelectFolderEnabled(true)
    allFoldersView.setMimeTypes('application/vnd.google-apps.folder')
    return allFoldersView

  rootFolder: ->
    view = new google.picker.DocsView()
    view.setIncludeFolders(true)
    view.setSelectFolderEnabled(true)
    view.setMimeTypes('application/vnd.google-apps.folder')
    view.setParent("root")
    return view
