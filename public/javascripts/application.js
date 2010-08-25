var VPB = VPB || {};

VPB = {
	// notifications
	notifications: {
		constructMessage:function(messageType,message){
			// create notification for each message
			$j('#messages').jnotifyAddMessage({
				type:messageType,
				text:message,
				permanent:false,
			});
		},
		init:function(){
			if($j('#messages .msg').length < 1) {return;}
			// initialize jnotification plugin
			$j('#messages')
			 .jnotifyInizialize({
           oneAtTime: true,
           appendType: 'append'
       })
       .css({
          'position': 'absolute',
          'right': '0px',
          'width': '100%',
          'z-index': '9999',
					'text-align': 'center'
       });

			// get message data, and construct messages with it
			$j('#messages .msg').each(function(idx,el){
				
					var msg = $j(el);
					var type = undefined;
					
					// sniff out message type by rendered classname
					if(msg.hasClass('notice') || msg.hasClass('message')){
						type = 'message';
					} else if (msg.hasClass('warning') || msg.hasClass('error')) {
						type = 'error';
					}
					
				// construct a message
				if(msg.text() !== null || msg.text() !== '') {
					VPB.notifications.constructMessage(type,msg.text());
				}
				
				// post construction styling - not sure how else to apply styling to text.
				// since this element is created dynamically, and there are 2 spans nested.
				$j('.jnotify-item span:last').addClass('text');
			});
		}
	},
	// duration selector
	durationSelector: {
		convert:function(time) {
			hours = parseInt( time / 3600 ) % 24;
			minutes = parseInt( time / 60 ) % 60;
			seconds = time % 60;
			result = (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds  < 10 ? "0" + seconds : seconds);
			return result;
		},
		prevStart:undefined,
		prevStop:undefined,
		handleSlide:function(event, ui) {
			var start = VPB.durationSelector.convert(ui.values[0]);
			var end   = VPB.durationSelector.convert(ui.values[1]);
			$j('#section_video_start_time').attr('value', start);
			$j('#section_video_stop_time').attr('value', end);
		},
		handleStop:function(event, ui) {
			// if stopping point is different than what it was previously set to..
			if(ui.values[0] !== this.prevStart) {
				VPB.modalVideoPlayer.seek(ui.values[0]);
			} else if (ui.values[1] !== this.prevStop) {
				VPB.modalVideoPlayer.seek(ui.values[1]);
			}
			VPB.modalVideoPlayer.pause();
			
			// hold this offsets for the next update.
			this.prevStart = ui.values[0];
			this.prevStop  = ui.values[1];
		},
		init: function() {
			// make sure we have time data to work with
			if(!VPB.SectionTimeData) { return; }
			// configure slider
			$j('#duration_slider').slider({
				range: true,
				min:0,
				max:VPB.SectionTimeData[VPB.currentSection].length,
				values:[VPB.SectionTimeData[VPB.currentSection].start,VPB.SectionTimeData[VPB.currentSection].stop],
				slide:VPB.durationSelector.handleSlide,
				stop:VPB.durationSelector.handleStop
			});
		}
	},
	homePageSlideShow: {
		init:function() {
			// if there's no slideshow to work with, just stop.
			if(! $j('#slideshow').length) { return; }
			
			$j('#slideshow').after('<div class="paging"><ul id="thumbs">').cycle({ 
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
	sectionTabs:{
		// determine which tab index we should be on based on the url.
		selectInitialTab:function () {
		  var tabIndex = 0;
		  $j('li.tab a').each(
		    function(idx,el){
		      if(el.href !== undefined && el.href !== '')
		        if(window.location.href.match(el.href) !== null) {
		          tabIndex = idx;
		        }
		    });

			// update global section index.
			VPB.currentSection = tabIndex;

			// update current section stop time
			VPB.currentStop = VPB.SectionTimeData[tabIndex].stop;

			return tabIndex;
		},
		getCurrentTab:function() {
			$j('#tabs .tab').each(function(idx,el) {
				if($j(el).hasClass('ui-tabs-selected')) {
					return idx;
				}
			});
		},
		// tab select callback handler
		showCallback:function(event,ui) {
			// update the videoplayer to the appropriate offset.
			if(VPB.SectionTimeData) {
				VPB.videoPlayer.seek(VPB.SectionTimeData[ui.index].start);
			}
		},
		updateTabIndex:function(event,ui) {
			VPB.currentSection = ui.index;
		},
		handlePlayahead:function(data,id) {
		},
		sectionTabs:undefined,
		init:function() {
			// if we don't have section time data and tabs to work on, just stop.
			if( (! $j('#tabs').length) || !VPB.SectionTimeData) { return; }
			this.sectionTabs = $j("#tabs").tabs({
									selected:this.selectInitialTab(), // preselect tab
					  				show:this.showCallback
								});
								
			$j(document).bind('tabsselect', this.updateTabIndex);
			// listen for whne the video player is ready, then enable tabs
			$j(document).bind('videoPlayerReady', function(){});
		}
	},
	sectionEditor:{
		handleCancel:function(event) {
			$j(event.target).parents().filter('.tab_content').addClass('view');
			$j(event.target).parents().filter('.tab_content').removeClass('edit');
			return false;
		},
		handleTiming:function(event) {
			VPB.videoPlayer.pause();
			VPB.modalVideoPlayer.init();
			return false;
		},
		handleEdit:function(event) {
			// get current tab
			var currentTabIndex = undefined;
			$j('#tabs .tab').each(function(idx,el) {
				if($j(el).hasClass('ui-tabs-selected')) {
					currentTabIndex = idx;
				}
			});
			var currentTab = $j('.tab_content')[currentTabIndex];
			
			// set it to edit more
			$j(currentTab).addClass('edit');
			$j(currentTab).removeClass('view');
		},
		handleTabChange:function(e) {
			var currentTab = $j('.tab_content').each(function(idx,el) {
				$j(el).addClass('view');
				$j(el).removeClass('edit');
			});
		},
		init:function() {
			// wire up buttons
			$j('.close').live('click', function() {
				parent.$j.fancybox.close();
			});
			$j('.edit-button').click(this.handleEdit);
			$j('.cancel-button').click(this.handleCancel);
			$j('.timing-button').click(this.handleTiming);
			// hook up modal popup to timing editor
			$j('.timing-button').fancybox(
				{
					modal:false,
					autoDimensions:false,
					overlayOpacity:.8,
					scrolling:'no',
					width:370,
					height:235,
					showCloseButton:true,
					enableEscapeButton:true
				}
			);
			
			// listen for tab changes
			$j(document).bind('tabsselect', this.handleTabChange);
			
		}
	},
	videoPlayer: {
		player:undefined, // kdp handle
		ready:false,
		changeListener:function(data,id){},
		handlePlayerUpdatePlayhead:function(data,id) {
			$j(document).trigger("videoPlayahead", data);
		},
		handleScrubberDragEnd:function(data,id) {
			$j(document).trigger("scrubberDragEnd", data);
		},
		handlePlayerSeekEnd:function(date,id) {
			$j(document).trigger("playerSeekEnd", data);
		},
		handlePlayerReady:function(data,id) {
			VPB.videoPlayer.init();
			$j(document).trigger("videoPlayerReady", data);
		},
		play:function(){
			this.player.sendNotification('doPlay');
		},
		stop:function() {
			this.player.sendNotification('doStop');
		},
		pause:function(){
			this.player.sendNotification('doPause');
		},
		seek:function(offset) {
			if(this.player) {
				this.player.sendNotification('doPlay');
				this.player.sendNotification('doSeek', offset);
				this.player.sendNotification('doPause');
			}
		},
		init:function(){
			// Listen for when the player section is over and pause.
			$j(document).bind('videoPlayahead',function(e,data){
				if(data > VPB.currentStop && VPB.currentStop !== 0) {
					VPB.videoPlayer.pause();
				}
			});
		}
	},
	modalVideoPlayer: {
		player:undefined, // kdp handle
		ready:false,
		changeListener:function(data,id){},
		handlePlayerUpdatePlayhead:function(data,id) {
			$j(document).trigger("videoPlayahead", data);
		},
		handleScrubberDragEnd:function(data,id) {
			$j(document).trigger("scrubberDragEnd", data);
		},
		handlePlayerSeekEnd:function(date,id) {
			$j(document).trigger("playerSeekEnd", data);
		},
		handleBytesDownloadedChange:function(data,id){
			$j(document).trigger("modalVideoPlayerReady", data);
		},
		play:function(){
			this.player.sendNotification('doPlay');
		},
		stop:function() {
			this.player.sendNotification('doStop');
		},
		pause:function(){
			this.player.sendNotification('doPause');
		},
		seek:function(offset) {
			if(this.player) {
				this.player.sendNotification('doPlay');
				this.player.sendNotification('doSeek', offset);
				this.player.sendNotification('doPause');
			}
		},
		init:function(){
			$j(document).bind('modalVideoPlayerReady', VPB.durationSelector.init);
		}
	},
	// initialize page
	init:function() {
		VPB.notifications.init();
		VPB.sectionTabs.init();
		VPB.homePageSlideShow.init();
		VPB.sectionEditor.init();
		// Set video offset to the initial section tab offset.
		// TODO: should this be wired up somewhere else?
		if( $j('#tabs').length && VPB.SectionTimeData ) {
			$j(document).bind('videoPlayerReady', function(){
				VPB.videoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
			});
			$j(document).bind('modalVideoPlayerReady', function(){
				VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
			});
		}
	}
};


// kaltura player callback
// This is the first call the flash player will make when it's loaded.
function jsCallbackReady () {

	// set videoplayer handle
	VPB.videoPlayer.player = $j('#kplayer').get(0);
	VPB.modalVideoPlayer.player = $j('#kplayer_duration').get(0);
	
	// wire up video player listeners
	VPB.videoPlayer.player.addJsListener("playerStateChange", "VPB.videoPlayer.changeListener");
	VPB.videoPlayer.player.addJsListener("kdpReady", "VPB.videoPlayer.changeListener");
	VPB.videoPlayer.player.addJsListener("playerUpdatePlayhead", "VPB.videoPlayer.handlePlayerUpdatePlayhead");
	
	// this is when the player is actually ready for scripting
	VPB.videoPlayer.player.addJsListener("bytesDownloadedChange", "VPB.videoPlayer.handlePlayerReady");
	VPB.modalVideoPlayer.player.addJsListener("bytesDownloadedChange", "VPB.modalVideoPlayer.handleBytesDownloadedChange");
	
	VPB.videoPlayer.player.addJsListener("scrubberDragEnd", "VPB.videoPlayer.handleScrubberDragEnd");
	VPB.videoPlayer.player.addJsListener("playerSeekEnd", "VPB.videoPlayer.handlePlayerSeekEnd");
}

$j(document).ready(VPB.init);