// This should probably be in the assets javascripts area
// but I'm running low on time.

var tribs = {
	init: function(){

		if($('.advanced-search').length > 0){
			$fs = $('.advanced-search fieldset').eq(0);
			$('select', $fs).selectToAutocomplete();
			$('input:radio', $fs).change(function(e) {
				$('#search_reported_only').toggle(!$('#search_reported_false').is(':checked'));
			});
		}
	}
};

$(function(){
	tribs.init();
});