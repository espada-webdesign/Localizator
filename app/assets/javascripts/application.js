// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require jquery
//= require selectize
//= require_tree .
//= stub zload

function refresh_layer_header(){
  $.each($('h2.layer-header'), function( index, header ) {
    var show_h2 = false;
    $.each($(header).nextAll(), function( index, child ) {
      if(!$(child).hasClass('hidden')){
          show_h2 = true;
          return false;
      }
    });
    if(!show_h2){
      $(header).addClass('hidden');
    }
    else{
      $(header).removeClass('hidden');
    }
  });
}

function refresh_options(query){
  if (!query.length){
    $.each($('.rowitem'), function( index, field ) {
      $(field).removeClass('hidden');
      if(window.markers[$(field).attr('index')]._map == null){
        window.markers[$(field).attr('index')].addTo(map);
      }
    });
  }
  else{
    $.each($('.rowitem'), function( index, field ) {
      var showStore = true;
      $.each(query.split(' '), function( index2, word ) {
        var word_included = false;
        word = word.toLowerCase();
        if(($(field).attr('address')).toLowerCase().includes(word)){
          word_included = true;
        }
        if(($(field).attr('city')).toLowerCase().includes(word)){
          word_included = true;
        }
        if(($(field).attr('name')).toLowerCase().includes(word)){
          word_included = true;
        }
        if(($(field).attr('postcode')).toLowerCase().includes(word)){
          word_included = true;
        }
        if(!word_included){
          showStore = false;
        }
      });
      if(!showStore){
        $(field).addClass('hidden');
        window.markers[$(field).attr('index')].remove();
      }
      else{
        $(field).removeClass('hidden');
        if(window.markers[$(field).attr('index')]._map == null){
          window.markers[$(field).attr('index')].addTo(map);
        }
      }
    });
  }
  refresh_layer_header();
  var defined_markers = new Array();
  for(var i = 0; i < window.markers.length; i++){
    if(window.markers[i] != undefined && window.markers[i]._map != null){
      defined_markers.push(window.markers[i]);
    }
  }
  if(defined_markers.length > 0){
    var group = new L.featureGroup(defined_markers);
    map.fitBounds(group.getBounds().pad(0.5));
  }
}

document.addEventListener('turbolinks:load', function() {
   $('#search').selectize({
     valueField: 'title',
     labelField: 'title',
     searchField: 'title',
     placeholder: 'Začněte psát adresu...',
     create: true,
     createOnBlur: true,
     maxItems: 1,
     sortField: 'text',
     onInitialize: function() {
       selectize = this;
       $('div.selectize-control').removeClass('single').addClass('multi');
       var timeout = null;
       $("#search-selectized").on("input", function(){
         if (timeout !== null) {
            clearTimeout(timeout);
         }
         timeout = setTimeout(function () {
           var query = $("#search-selectized").val();
           refresh_options(query);
         }, 500);

       });
       var $select = $("#search").selectize();
       var control = $select[0].selectize;
       $.each($('.rowitem'), function( index, field ) {
         control.addOption({
          id: $(field).attr('index'),
          title: $(field).attr('name') + ' ' + $(field).attr('address') + ' ' + $(field).attr('city') +  ' ' + $(field).attr('postcode'),
        });
       });
     },
     render: {
        option_create: function(data, escape) {
          return '<div class="create option">Hledat <strong>' + escape(data.input) + '</strong>&hellip;</div>';
        }
      },
     onType: function (str) {
          if (str === "") {
              this.close();
          }
      },
     onItemAdd: function (value, $item) {
         refresh_options(value);
     },
     onDropdownOpen: function ($dropdown) {
      // Manually prevent dropdown from opening when there is no search term
      if (!this.lastQuery.length) {
        this.close();
      }
     },
     onFocus: function (){
        var value = this.getValue();
        if (value.length > 0) {
            this.clear(true);
            this.$control_input.val(value);
        }
        else{
          $('.rowitem').removeClass("hidden");
        }
    }
   });

   document.addEventListener("turbolinks:before-cache", function() {
     $('body').find("select").each(function(){
       if ($(this)[0].selectize) {
          $(this)[0].selectize.destroy();
       }
     });
   });

});
