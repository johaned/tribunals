/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

moj.init();
$(document).ready(function(){
    $('.decisions').removeHighlight().highlight($('#search_query').val());
});
