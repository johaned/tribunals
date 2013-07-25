/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.decisions = (function() {
  "use strict";

  var init,
      cacheEls,
      bindEvents,
      resetFilters,
      searchToggle,
      $fs,
      $resetBtn;

  init = function() {

    cacheEls();
    bindEvents();

    if( $( '.advanced-search' ).length > 0 ) {
      $( 'select', $fs ).selectToAutocomplete();
    }

  };

  cacheEls = function() {
    $fs = $( '.advanced-search fieldset' ).eq( 0 );
    $resetBtn = $( 'button[type=reset]', $fs ).eq( 0 );
  };

  bindEvents = function() {
    $( 'input:radio', $fs ).on( 'change', searchToggle );

    $resetBtn.on('click', function ( e ) {
      e.preventDefault();
      resetFilters();  
    });
  };

  resetFilters = function() {
    $resetBtn.closest( 'form' ).find( 'input[type=text], input.ui-autocomplete-input' ).val( '' );
    $('#search_reported_all').trigger('click');
  };

  searchToggle = function() {
    $( '#search_reported_only' ).toggle( !$( '#search_reported_false' ).is( ':checked' ) );
  };

  // public

  return {
    init: init
  };
}());
