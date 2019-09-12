# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



get_store_name = (name) ->
  if name
    stores_names[name]
  else
    others_string

get_all_stores_array = ->
  Object.values stores_names

refresh_layer_header = ->
  $.each $('h2.layer-header'), (index, header) ->
    show_h2 = false
    $.each $(header).nextAll(), (index, child) ->
      if !$(child).hasClass('hidden')
        show_h2 = true
        return false
      return
    if !show_h2
      $(header).addClass 'hidden'
    else
      $(header).removeClass 'hidden'
    return
  return

refresh_options = (query) ->
  if !query.length
    $.each $('.rowitem'), (index, field) ->
      if !$(field).parent().hasClass('hidden')
        $(field).removeClass 'hidden'
        if window.markers[$(field).attr('index')]._map == null
          window.markers[$(field).attr('index')].addTo map
      else
        $(field).addClass 'hidden'
        window.markers[$(field).attr('index')].remove()
      return
  else
    $.each $('.rowitem'), (index, field) ->
      showStore = true
      if !$(field).parent().hasClass('hidden')
        $.each query.split(' '), (index2, word) ->
          word_included = false
          word = word.toLowerCase()
          if $(field).attr('address').toLowerCase().includes(word)
            word_included = true
          if $(field).attr('city').toLowerCase().includes(word)
            word_included = true
          if $(field).attr('name').toLowerCase().includes(word)
            word_included = true
          if $(field).attr('postcode').toLowerCase().includes(word)
            word_included = true
          if !word_included
            showStore = false
          return
      else
        showStore = false
      if !showStore
        $(field).addClass 'hidden'
        window.markers[$(field).attr('index')].remove()
      else
        $(field).removeClass 'hidden'
        if window.markers[$(field).attr('index')]._map == null
          window.markers[$(field).attr('index')].addTo map
      return
  refresh_layer_header()
  defined_markers = new Array
  i = 0
  while i < window.markers.length
    if window.markers[i] != undefined and window.markers[i]._map != null
      defined_markers.push window.markers[i]
    i++
  if defined_markers.length > 0
    group = new (L.featureGroup)(defined_markers)
    map.fitBounds group.getBounds().pad(0.5)
  return

refresh_dropdown = ->
  $select = $('#search').selectize()
  control = $select[0].selectize
  control.clearOptions()
  $.each $('.rowitem'), (index, field) ->
    if !$(field).hasClass('hidden')
      control.addOption
        id: $(field).attr('index')
        title: $(field).attr('name') + ' ' + $(field).attr('address') + ' ' + $(field).attr('city') + ' ' + $(field).attr('postcode')
    return
  return

document.addEventListener 'turbolinks:load', ->
  $('#search').selectize
    valueField: 'title'
    labelField: 'title'
    searchField: 'title'
    placeholder: 'Začněte psát adresu...'
    create: true
    createOnBlur: true
    maxItems: 1
    sortField: 'text'
    onInitialize: ->
      selectize = this
      $('div.selectize-control').removeClass('single').addClass 'multi'
      timeout = null
      $('#search-selectized').on 'input', ->
        if timeout != null
          clearTimeout timeout
        timeout = setTimeout((->
          query = $('#search-selectized').val()
          refresh_options query
          return
        ), 500)
        return
      refresh_dropdown()
      return
    render: option_create: (data, escape) ->
      '<div class="create option">Hledat <strong>' + escape(data.input) + '</strong>&hellip;</div>'
    onType: (str) ->
      if str == ''
        @close()
      return
    onItemAdd: (value, $item) ->
      refresh_options value
      return
    onDropdownOpen: ($dropdown) ->
      # Manually prevent dropdown from opening when there is no search term
      if !@lastQuery.length
        @close()
      return
    onFocus: ->
      value = @getValue()
      if value.length > 0
        @clear true
        @$control_input.val value
      else
        $('.rowitem').removeClass 'hidden'
      return
  $('#layer-search').selectize
    valueField: 'title'
    labelField: 'title'
    searchField: 'title'
    create: false
    maxItems: 1
    onInitialize: ->
      selectize = this
      $select = $('#layer-search').selectize()
      control = $select[0].selectize
      all_stores = get_all_stores_array()
      control.addOption
        id: 0
        title: all_stores_string
      i = 1
      i = 1
      while i < all_stores.length + 1
        control.addOption
          id: i
          title: all_stores[i - 1]
        i++
      control.addOption
        id: i
        title: others_string
      control.setValue all_stores_string
      return
    onChange: ->
      $select = $('#layer-search').selectize()
      control = $select[0].selectize
      cur_store = control.getValue()
      if cur_store != all_stores_string and cur_store
        $('div.layer-stores').addClass 'hidden'
        if cur_store == others_string
          $('div.layer-stores[index=' + others_key + ']').removeClass 'hidden'
        else
          $.each stores_names, (key, val) ->
            if val == cur_store
              $('div.layer-stores[index=' + key + ']').removeClass 'hidden'
            return
      else
        $('div.layer-stores').removeClass 'hidden'
      $select = $('#search').selectize()
      control = $select[0].selectize
      refresh_options control.getValue()
      refresh_dropdown()
      return
  document.addEventListener 'turbolinks:before-cache', ->
    $('body').find('select').each ->
      if $(this)[0].selectize
        $(this)[0].selectize.destroy()
      return
    return
  return
