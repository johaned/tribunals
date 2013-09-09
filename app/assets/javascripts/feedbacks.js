$('#feedback_text').keyup(function(){
  var charlimit = 2000,
      notice = $('#char-limit');  
  if($(this).val().length > charlimit) {
    $(this)
      .val($(this).val().substr(0, charlimit))
      .css('outline', 'solid 3px #ff0000');
    notice.css('color', '#ff0000')
  } else {
    $(this).add(notice).removeAttr('style');
  }
});

var sendFeedbackToGA = function(){
  $('#new_feedback').submit(function(){
    var rating = $('input:checked').attr('value');
    if(rating !== undefined) {
      ga('send', 'event', 'Feedback', 'Rating', rating);
    }
  });
};
