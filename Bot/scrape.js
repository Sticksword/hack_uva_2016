$(document).ready(function() {
	var count = 0;
	$('._3ydv').each(function () {
		var eventIDRaw = $(this).find('._1qdd').find('a').attr('href');
		var eventID = eventIDRaw.substring(eventIDRaw.indexOf("/events/") + 8, eventIDRaw.indexOf('/?'))
		var name = $(this).find('._1qdd a').html();
		var timeRaw = $(this).find('._5p0a').html();
		var time = timeRaw.substring(timeRaw.indexOf('<span>') + 6, timeRaw.indexOf('</span>'));
		var startDate = time.substring(0, time.indexOf(" -"));
		var location = $(this).find('._5inl').html();
		var imageURL = $(this).parent().parent().find('._mxq').find('.uiScaledImageContainer').find('.img').attr('src');
		//var picture = 	; 
		//var html = $(this).html();
		//var event_id = div_id.substring(15);
		//var name = $(this + ' a').html();
		//var time = $(this + ' ._5p0a span').html();
		console.log(name);
	  	//console.log(name + " " + time + " " + location);
	  	//	console.log(imageURL);	
	  	//console.log(startDate);
	  	if (count == 0) {
		  	$.ajax({
				url: "//ec2-54-164-108-53.compute-1.amazonaws.com:3000/api/events/",
				//url: 'localhost/postForward.php',
				//url: 'http://localhost/dummy.php',
				method: "POST",
				data: {
					id: eventID,
					name: name,
					date: startDate,
					location: location,
					photo_url: imageURL
				},
				success: function(response) {
					//console.log('hello');
					console.log(response);
				}
			}); 
			count++;
		  }
	});	
	
});

