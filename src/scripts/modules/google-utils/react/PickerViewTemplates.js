// import _ from 'underscore';
const sheets = () => {
  const {google} = window;
  const view = new google.picker.DocsView(google.picker.ViewId.SPREADSHEETS);
  view.setMimeTypes('application/vnd.google-apps.spreadsheet');
  view.setIncludeFolders(true);
  view.setOwnedByMe(false);
  // view.setSelectFolderEnabled(true)
  view.setParent('root');
  return view;
};

const sharedSheets = () => {
  const {google} = window;
  const allFoldersView = new google.picker.DocsView(google.picker.ViewId.SPREADSHEETS);
  allFoldersView.setIncludeFolders(true);
  allFoldersView.setMode(google.picker.DocsViewMode.GRID);
  // allFoldersView.setSelectFolderEnabled(true)
  return allFoldersView;
};

export default {

  sheetsGroup() { // NOT WORKING
    let group = new window.google.picker.ViewGroup(sheets());
    group = group.addLabel('User sheets');
    group = group.addView(sharedSheets());
    group = group.addLabel('shared sheets');
    return group;
  },

  sheets() {
    return sheets();
  },

  sharedSheets() {
    return sharedSheets();
  },

  root(foldersOnly) {
    const view = new window.google.picker.DocsView();
    view.setIncludeFolders(true);
    if (foldersOnly) {
      view.setSelectFolderEnabled(true);
      view.setMimeTypes('application/vnd.google-apps.folder');
    }
    view.setParent('root');
    return view;
  },

  flat(foldersOnly) {
    const allFoldersView = new window.google.picker.DocsView();
    allFoldersView.setIncludeFolders(true);
    if (foldersOnly) {
      allFoldersView.setSelectFolderEnabled(true);
      allFoldersView.setMimeTypes('application/vnd.google-apps.folder');
    }
    return allFoldersView;
  },

  recent(foldersOnly) {
    const {google} = window;
    const recentView = new google.picker.DocsView(google.picker.ViewId.RECENTLY_PICKED);
    if (foldersOnly) {
      recentView.setMimeTypes('application/vnd.google-apps.folder');
      recentView.setSelectFolderEnabled(true);
    }
    recentView.setIncludeFolders(true);
    return recentView;
  },

  recentFolders() {
    const {google} = window;
    const recentView = new google.picker.DocsView(google.picker.ViewId.RECENTLY_PICKED);
    recentView.setMimeTypes('application/vnd.google-apps.folder');
    recentView.setSelectFolderEnabled(true);
    recentView.setIncludeFolders(true);
    return recentView;
  },

  flatFolders() {
    const {google} = window;
    const allFoldersView = new google.picker.DocsView();
    allFoldersView.setIncludeFolders(true);
    allFoldersView.setSelectFolderEnabled(true);
    allFoldersView.setMimeTypes('application/vnd.google-apps.folder');
    return allFoldersView;
  },

  rootFolder() {
    const {google} = window;
    const view = new google.picker.DocsView();
    view.setIncludeFolders(true);
    view.setSelectFolderEnabled(true);
    view.setMimeTypes('application/vnd.google-apps.folder');
    view.setParent('root');
    return view;
  }
};
