$(function() {
		   
	$('#slider').after('<div class="paging"><ul id="thumbs">').cycle({ 
		fx: 'fade',
		pager: '#thumbs',
		pagerAnchorBuilder: function(idx, slide) {
			
			return '<li><a href="#"></a></li>';
			
		},
		activePagerClass: 'active',
		pause: 1,
		pauseOnPagerHover: 1
	});

});