moj.Modules.decisions = {
  init: function() {

    if( $( '.advanced-search' ).length > 0 ) {
      var $fs = $( '.advanced-search fieldset' ).eq( 0 );
      $( 'select', $fs ).selectToAutocomplete();
      $( 'input:radio', $fs ).change(function( e ) {
        $( '#search_reported_only' ).toggle( !$( '#search_reported_false' ).is( ':checked' ) );
      });
    }

    $( 'button[type=reset]' ).click(function ( e ) {
      var $btn = $( this );
      e.preventDefault();
      $btn.closest( 'form' ).find( 'input[type=text], input.ui-autocomplete-input' ).val( '' );
    });

  }
};
