###
  Entry point for non app pages, provides some basic parts implemented in React
###

require './utils/react-shim'

global.kbcApp =
  helpers: require './helpers'
  parts:
    ProjectSelect: require './react/layout/project-select/ProjectSelect'
    CurrentUser: require './react/layout/CurrentUser'
    ProjectsList: require './react/layout/project-select/List'
    NewProjectModal: require './react/layout/NewProjectModal'