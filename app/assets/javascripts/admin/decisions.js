// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

moj.Modules.admin_decisions = function(){
  "use strict";

  var $form,

  init = function() {
    if( $( 'form.edit_decision' ).length > 0 ) {
      $form = $( 'form.edit_decision' ).eq( 0 );
      init_arrays();
    }

    $( document ).on( 'click', 'a.delete', function( e ) {
      e.preventDefault();
      delete_element( $(e.target) );
    });
    $( document ).on( 'click', 'a.add', function( e ) {
      e.preventDefault();
      add_element( $(e.target) );
    });
    $( document ).on( 'change', '.split', function() {
      var $row = $( this ).closest( '.row' );
      store_values( $row );
    });
  },

  init_arrays = function() {
    $form.find( '.array input[type="text"]' ).each( function() {
      split_arrays( $(this) );
    });
  },

  split_arrays = function( $el ) {
    var val = $el.val(),
        $row = $el.closest( '.row' ),
        arr,
        x,
        htmlStr = '';

    if( val === '{}' ) {
      val = '';
      arr = [''];
    } else {
      val = val.substr( 1, val.length - 2 );
      arr = val.split( ',' );
    }
    for ( x = 0; x < arr.length; x++ ) {
      arr[x] = strip_quotes( arr[x] );
    }
    $row.data( 'array', arr ).val( val );
    $el.addClass( 'original' ).hide();
    render_textboxes( $el );
  },

  render_textboxes = function( $el ){
    var $row = $el.closest( '.row' ),
        x,
        arr = $row.data( 'array' ),
        htmlStr = '';

    $row.find('.single').remove();

    for( x = 0; x < arr.length; x++ ) {
      htmlStr += '<div class="single"><input type="text" class="split" value="'+arr[x]+'">';
      if( arr.length > 1 ){
        htmlStr += '<a href="#" class="delete">delete</a>';
      }
      if( x === 0 ){
        htmlStr += '<a href="#" class="add">add</a>';
      }
      htmlStr += '</div>';
    }
    $el.before( htmlStr );
    store_values( $row );
  },

  add_element = function( $link ) {
    var $row = $link.closest( '.row' ),
        arr = $row.data( 'array' );

    arr[arr.length] = '';
    $row.data( 'array', arr );
    render_textboxes( $row.find( '.original' ) );
  },

  delete_element = function( $link ) {
    var $row = $link.closest( '.row' ),
        i = $row.find( '.delete' ).index( $link ),
        arr = $row.data( 'array' );

    arr.splice( i, 1 );
    $row.data( 'array', arr );
    render_textboxes( $row.find( '.original' ) );
  },

  store_values = function( $row ) {
    var str = '{',
        arr = [],
        x;

    $row.find( '.split' ).each( function() {
      arr[arr.length] = $( this ).val();
    });

    for( x = 0; x < arr.length; x++ ){
      str += '"' + arr[x] + '"';
      if( x < arr.length-1 ){
        str += ', ';
      }
    }
    str += '}';

    $row.data( 'array', arr ).find( '.original' ).val( str );
  },

  strip_quotes = function ( str ){
    if( str.charAt(0) === '"' ){
      str = str.substr( 1 );
    }
    if( str.charAt(str.length-1) === '"'){
      str = str.substr( 0, str.length-2 );
    }
    return str;
  };

  // public

  return {
    init: init
  };

}();
