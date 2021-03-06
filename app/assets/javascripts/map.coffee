# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.load = () ->
  window.markers = []
  window.divs = []
  window.map = L.map('mapid').setView([
    49.7
    15.5
  ], 8)


  $('document').on 'turbolinks:load', ->
    $('.selectize').selectize({
          create: true,
          sortField: 'text'
      })
    return

  LeafIcon = L.Icon.extend(options:
    shadowSize: [
      0
      0
    ]
    iconAnchor: [
      0
      0
    ]
    shadowAnchor: [
      4
      62
    ]
    popupAnchor: [
      0
      0
    ])
  store_images = new Object
  store_images[others_key] = new LeafIcon(iconUrl: '/images/' + others_key + '.png')
  $.each stores_names, (key, val) ->
    path = '/images/' + key + '.png'
    store_images[key] = new LeafIcon(iconUrl: path)
    return

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFydHljYXNoZXciLCJhIjoiY2p3bzBwa2NiMmQyczQ5bzIwenFrbWNmYiJ9.8vHaT7NMz3mszqg9uqu9hw',
    maxZoom: 18
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' + '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' + 'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
    id: 'mapbox.streets').addTo map

  $ ->
    $('div.rowitem').each ->
      cur_layer = $(this).parent().attr('index')
      pop_index = $(this).attr('index')
      markers[$(this).attr('index')] = L.marker([
        $(this).attr('latitude')
        $(this).attr('longitude')
      ],{icon: store_images[cur_layer]}).addTo(map).bindPopup('<b>' + $(this).attr('name') + '</b><br>' + $(this).attr('address') + '<br>' + $(this).attr('city')).on('popupopen', (popup) ->
        $('div.rowitem[index="' + pop_index + '"]').addClass('selected-store')
        $('div.side-bar').scrollTo('div.rowitem[index=' + pop_index + ']');
        return
      ).on 'popupclose', (popup) ->
        $('div.rowitem').removeClass('selected-store')
        return
    divs.push $(this)

  $ ->
    $('div.rowitem').click ->
      $('.selected-store').removeClass "selected-store"
      $(this).addClass("selected-store")
      map.setView([
        $(this).attr("latitude")
        $(this).attr("longitude")
        ], 15)
      window.markers[parseInt($(this).attr("index"))].openPopup()

  window.search_stores = (text) ->
    if(!!text)
      text = text.toLowerCase()
      $('div.rowitem' ).each ->
        $(this).addClass "hidden"
        map.removeLayer markers[$(this).attr("index")]
        str = $(this).attr("name") + " - " + $(this).attr("address") + " - " +  $(this).attr("city") + " - " +  $(this).attr("postcode")
        str = str.toLowerCase()
        if text.includes str
          $(this).removeClass "hidden"
          map.addLayer markers[$(this).attr("index")]
    else
      $('.hidden').each ->
        $(this).removeClass "hidden"
        map.addLayer markers[$(this).attr("index")]

  jQuery.fn.scrollTo = (elem, speed) ->
    $(this).animate { scrollTop: $(this).scrollTop() - ($(this).offset().top) + $(elem).offset().top }, if speed == undefined then 1000 else speed
    this

  ###
  $ ->
    $('i.material-icons').click ->
        text = $('#search').val()
        search_stores text
  ###
  $('#search').on 'keyup', (e) ->
    text = $('#search').val()
    if e.keyCode == 13
      search_stores text
    else if !(!!text)
      search_stores text
    return

  popup = L.popup()
  window.map.invalidateSize();
