# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->
  $('#select-packetery-branch').selectize
    valueField: 'title'
    labelField: 'title'
    searchField: 'title'
    placeholder: 'začněte psát adresu'
    create: false
    onInitialize: ->
      selectize = this
      return
    load: (query, callback) ->
      if !query.length
        return callback()
      $.ajax
        url: '/search/packetery?term=' + encodeURIComponent(query)
        type: 'GET'
        error: ->
          callback()
          return
        success: (res) ->
          callback res
          return
      return
    onChange: ->
      updateSelectedPacketery()
      return
  document.addEventListener 'turbolinks:before-cache', ->
    $('body').find('select').each ->
      if $(this)[0].selectize
        $(this)[0].selectize.destroy()
      return
    return
  return
