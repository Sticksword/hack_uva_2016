$(document).ready(function() {
	$('._4cbb').each(function () {
		var div_id = $(this).attr('id');
		var event_id = div_id.substring(15);
	  	console.log(div_id + " " + event_id);
	  	$.ajax(function() {
			url: "http://ericshiao.me/facebookScrape.php",
			method: 'POST',
			data: event_id;
			success: function(response) {
				console.log(response.name);
			}
		});
	});	
	
});

