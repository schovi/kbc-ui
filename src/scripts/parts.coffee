###
  Entry point for non app pages, provides some basic parts implemented in React
###
global.kbcApp =
  helpers: require './helpers'
  parts:
    ProjectSelect: require './react/layout/project-select/ProjectSelect'