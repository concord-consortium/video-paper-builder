var VPB = VPB || {};

VPB = {
	// duration selector
	durationSelector: {
		convert:function(time) {
			hours = parseInt( time / 3600 ) % 24;
			minutes = parseInt( time / 60 ) % 60;
			seconds = time % 60;
			result = (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds  < 10 ? "0" + seconds : seconds);
			return result;
		},
		handleSlide:function(event, ui) {
			var start = VPB.durationSelector.convert(ui.values[0]);
			var end   = VPB.durationSelector.convert(ui.values[1]);
			$j('#section_video_start_time').attr('value', start);
			$j('#section_video_stop_time').attr('value', end);
		},
		handleStop:function(event, ui) {
			//console.log('finished');
		},
		init: function() {
			// make sure we have time data to work with
			if(!VPB.SectionTimeData) { return; }
			
			// configure slider
			$j('#slider').slider({
				range: true,
				min:0,
				max:VPB.SectionTimeData.length,
				values:[VPB.SectionTimeData.start,VPB.SectionTimeData.stop],
				slide:this.handleSlide,
				stop:this.handleStop
			});
		}
	},
	homePageSlideShow: {
		init:function() {
			$j('#slider').after('<div class="paging"><ul id="thumbs">').cycle({ 
				fx: 'fade',
				pager: '#thumbs',
				pagerAnchorBuilder: function(idx, slide) {
					return '<li><a href="#"></a></li>';
				},
				activePagerClass: 'active',
				pause: 1,
				pauseOnPagerHover: 1
			});
		}
	},
	// initialize page
	init:function() {
		VPB.homePageSlideShow.init();
		VPB.durationSelector.init();
	}
};

// kick off page load
$j(document).ready(VPB.init);