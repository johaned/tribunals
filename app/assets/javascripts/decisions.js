/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.Modules.decisions = (function() {
  "use strict";

  var init;

  init = function() {

    if( $( '.advanced-search' ).length > 0 ) {
      var $fs = $( '.advanced-search fieldset' ).eq( 0 );
      $( 'select', $fs ).selectToAutocomplete();
      $( 'input:radio', $fs ).change(function() {
        $( '#search_reported_only' ).toggle( !$( '#search_reported_false' ).is( ':checked' ) );
      });
    }

    $( 'button[type=reset]' ).click(function ( e ) {
      var $btn = $( this );
      e.preventDefault();
      $btn.closest( 'form' ).find( 'input[type=text], input.ui-autocomplete-input' ).val( '' );
    });

  };

  // public

  return {
    init: init
  };
}());
