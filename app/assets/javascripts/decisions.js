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
      $form,
      $adv,
      resetBtns;

  init = function() {

    cacheEls();
    bindEvents();
    
  };

  cacheEls = function() {
    $form = $( '.search_form' ).eq( 0 );
    $fs = $( '.advanced-search fieldset', $form ).eq( 0 );
    resetBtns = $( 'button[type=reset]', $form );
    $adv = $( '#search_reported_only', $form );
  };

  bindEvents = function() {
    $( 'input:radio', $fs ).on( 'change', searchToggle );

    $( 'select', $fs ).selectToAutocomplete();

    $( resetBtns ).on( 'click', function ( e ) {
      e.preventDefault();
      resetFilters();  
    });
  };

  resetFilters = function() {
    $form.find( 'input[type=text], input.ui-autocomplete-input' ).val( '' );
    $( '#search_reported_all' ).trigger( 'click' );
    $adv.show();
  };

  searchToggle = function() {
    $adv.toggle( !$( '#search_reported_false' ).is( ':checked' ) );
  };

  // public

  return {
    init: init
  };
}());
