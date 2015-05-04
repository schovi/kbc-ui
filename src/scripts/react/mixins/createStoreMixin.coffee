

createStoreMixin = (stores...) ->

  StoreMixin =

    getInitialState: ->
      @getStateFromStores(@props)

    componentDidMount: ->
      stores.forEach((store) ->
        store.addChangeListener(@_handleStoreChanged)
      , @)

    componentWillUnmount: ->
      stores.forEach((store) ->
        store.removeChangeListener(@_handleStoreChanged)
      , @)

    _handleStoreChanged: ->
      if @isMounted()
        @setState(@getStateFromStores(@props))

  StoreMixin


module.exports = createStoreMixin

