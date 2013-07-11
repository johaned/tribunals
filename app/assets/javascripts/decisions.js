// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('button[type=reset]').click(function(evt) {
    evt.preventDefault();
    $(this).closest('form').find('input[type=text]').val('');
  });
});
