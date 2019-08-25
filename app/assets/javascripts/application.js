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


document.addEventListener('turbolinks:load', function() {
   $('#search').selectize({
     valueField: 'title',
     labelField: 'title',
     searchField: 'title',
     placeholder: 'Začněte psát adresu...',
     create: false,
     onInitialize: function() {
       selectize = this;
     },
     load: function(query, callback) {
       if (!query.length) return callback();
       $.ajax({
         url: '/search/show?term=' + encodeURIComponent(query),
         type: 'GET',
         error: function() {
           callback();
         },
         success: function(res) {
           callback(res);
         }
       });
     },
     onChange: function(){
       var text = $('#search').val();
       window.search_stores(text);
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
