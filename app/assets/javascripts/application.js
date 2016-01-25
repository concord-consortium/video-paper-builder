//= require jquery
//= require jquery_ujs
//= require jquery-noconflict
//= require prototype
//= require swfobject

//= require jquery.ui.slider
//= require jquery.ui.tabs

//= require jquery-progressbar
//= require jquery-cycle

//= require fancybox
//= require mousewheel
//= require jquery-jnotify
//= require effects
//= require tinymce
//= require s3_direct_upload
//= require aws-upload
//= require video-js-5.4.6

var VPB = VPB || {};

VPB = {
	playerReadyCount:0,
	sharingModal:{
		handleUnshareSuccess:function(){
			VPB.notifications.constructMessage('message','Sharing settings updated');
		},
		handleUnshareFailure:function(){
			VPB.notifications.constructMessage('error','Sharing settings not updated');
		},

		init:function(){
			// wire up unsharing button
			$j('body').delegate('.unshare', 'click',function(e) {
				var link = $j(e.target);
				$j.ajax(
					{
						url:link.attr('href'),
						context:document.body,
						success:VPB.sharingModal.handleUnshareSuccess,
						failure:VPB.sharingModal.handleUnshareFailure
					}
				);
				return false;
			});

			// wire up sharig button
			$j('.video_row .sharing_btn').each(function(idx,el) {
				$j(el).fancybox(
					{
					'scrolling':'no',
					'showCloseButton':false
					}
				);
			});

			// wire up s3 uploader
  		$j("#s3-uploader").S3Uploader();
			// strip out file serialization added in jQuery 1.9
			$j.propHooks.elements = {
        get: function(form) {
          if (jQuery.nodeName(form, "form")) {
					  if (jQuery(form).find("#do-not-serialize-file:hidden")) {
              return jQuery.grep(form.elements, function(elem) {
                  return !jQuery.nodeName(elem, "input") || (elem.type !== "file" && elem.id !== "do-not-serialize-file");
              });
						}
						else {
							return form.elements;
						}
          }
          return null;
        }
	    };

			// do the browser check
			var el = document.createElement('video');
			var notSupported = {
				file: !('File' in window),
				video: !el || !el.canPlayType || !el.canPlayType('video/mp4').replace(/no/, ''),
				messages: []
			}
			if (notSupported.file) {
				notSupported.messages.push('video uploads');
			}
			if (notSupported.video) {
				notSupported.messages.push('video playback');
			}
			if (notSupported.messages.length > 0) {
				$j("#browser_not_supported").html("<div id='inner_browser_not_supported'>This site may not work well for you as your browser does not support " + (notSupported.messages.join(' or ') + '.  <a href="https://browser-update.org/update.html">Please upgrade your browser.</a></div>')).show();
			}
		}
	},
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
			//if($j('#messages .msg').length < 1) {return;}
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
			VPB.SectionTimeData[VPB.currentSection].start = ui.values[0];
			VPB.SectionTimeData[VPB.currentSection].stop = ui.values[1];
			$j('#section_video_start_time').attr('value', VPB.durationSelector.convert(ui.values[0]));
			$j('#section_video_stop_time').attr('value', VPB.durationSelector.convert(ui.values[1]));
			VPB.positionSelector.reset();
		},
		handleStop:function(event, ui) {
			// if stopping point is different than what it was previously set to..
			if(ui.values[0] !== this.prevStart) {
				VPB.modalVideoPlayer.seek(ui.values[0]);
			}
			VPB.modalVideoPlayer.pause();
			VPB.positionSelector.reset();

			// hold this offsets for the next update.
			this.prevStart = ui.values[0];
			this.prevStop  = ui.values[1];
		},
		init: function() {
		  VPB.currentSection = VPB.sectionTabs.selectInitialTab();
		  if(VPB.currentSection === 'undefined') { return; }
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
	// position selector
	positionSelector: {
		percentage: 0,
		slider: null,
		getRange:function() {
			return VPB.SectionTimeData[VPB.currentSection].stop - VPB.SectionTimeData[VPB.currentSection].start;
		},
		seek:function(event, ui) {
			VPB.positionSelector.percentage = Math.min(1, Math.max(0, (ui.values[0] / 100)));
			VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start + (VPB.positionSelector.getRange() * VPB.positionSelector.percentage));
		},
		updateTimePosition:function(time) {
			VPB.positionSelector.percentage = Math.min(1, Math.max(0, (time - VPB.SectionTimeData[VPB.currentSection].start) / VPB.positionSelector.getRange()));
			VPB.positionSelector.updateSlider(100 * VPB.positionSelector.percentage);
		},
		reset:function() {
			VPB.positionSelector.percentage = 0;
			VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
		},
		updateSlider:function(value) {
			VPB.positionSelector.slider.slider("values", 0, value);
		},
		init: function() {
			// configure slider
			VPB.positionSelector.slider = $j('#position_slider').slider({
				range: false,
				min:0,
				max:100,
				values:[0],
				slide:VPB.positionSelector.seek,
				stop:VPB.positionSelector.seek
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
			// disable tabs after init so user cannot click on them before video is ready
			$j("#tabs").tabs({disabled: [0,1,2,3,4]});

			// listen for whne the video player is ready, then enable tabs
			if(VPB.video === true) { // ensure there's a video
				$j(document).bind('videoPlayahead', function(){
					VPB.sectionTabs.sectionTabs.tabs("option", "disabled", false);
				});
				// if there's a video, but no offset yet, we'll still need to enable the tabs
				if(VPB.SectionTimeData[VPB.currentSection].start === 0) {
					VPB.sectionTabs.sectionTabs.tabs("option", "disabled", false);
				}
			} else { //otherwise always enable tabs
				VPB.sectionTabs.sectionTabs.tabs("option", "disabled", false);
			}

			// wire up tab select handler
			$j(document).bind('tabsselect', this.updateTabIndex);
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
			var currentTabIndex = $j('#tabs').tabs().tabs('option', 'active');
			var currentTab = $j('.tab_content')[currentTabIndex];

			// set it to edit mode
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
					height:275,
					showCloseButton:true,
					enableEscapeButton:true
				}
			);

			// listen for tab changes
			$j(document).bind('tabsactivate', this.handleTabChange);

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
		  VPB.playerReadyCount = VPB.playerReadyCount + 1;
		  if (VPB.playerReadyCount == 1 || VPB.playerReadyCount == 2) {
			  VPB.videoPlayer.init();
			  $j(document).trigger("videoPlayerReady", data);
			}
		},
		play:function(){
			VPB.videoPlayer.player.sendNotification('doPlay');
		},
		stop:function() {
			VPB.videoPlayer.player.sendNotification('doStop');
		},
		pause:function(){
			//VPB.videoPlayer.player.sendNotification('doPause');
		},
		seek:function(offset) {
			// if necessary, convert offset into raw seconds.
			if(typeof(offset) === 'string') {
				var parts = offset.split(':');
				if(parts.length === 3) {
					var hour, min, sec;
					hour = parseInt(parts[0]);
					min  = parseInt(parts[1]);
					sec  = parseInt(parts[2]);
					offset = (hour * 60 * 60) + (min * 60) + (sec);
				}
			}
			if(VPB.videoPlayer.player) {
				VPB.videoPlayer.player.sendNotification('doPlay');
				VPB.videoPlayer.player.sendNotification('doSeek', offset);
				VPB.videoPlayer.player.sendNotification('doPause');
			}
		},
		show: function (video_url, thumbnail_url) {
			$j("#video_player_container").html([
				'<video id="video_player" class="video-js vjs-default-skin" controls preload="auto" width="360" height="202" poster="', thumbnail_url, '">',
					'<source src="', video_url, '" type="video/mp4" />',
				'</video>'
			].join(''));
			videojs("video_player", {}, function() {
				$j("#transcoding_status").hide();
				$j("#video_player_container").show();
			});
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
		play:function(){
			this.player.play();
		},
		stop:function() {
			this.player.pause();
		},
		pause:function(){
			this.player.pause();
		},
		seek:function(offset) {
			if(this.player) {
				this.player.play();
				this.player.currentTime(offset);
				this.player.pause();
			}
		},
		changedDuration: function () {

		},
		show: function (video_url, thumbnail_url) {
			$j("#modal_video_player_container").html([
				'<video id="modal_video_player" class="video-js vjs-default-skin" controls preload="auto" width="267" height="150" poster="', thumbnail_url, '">',
					'<source src="', video_url, '" type="video/mp4" />',
				'</video>'
			].join(''));
			VPB.modalVideoPlayer.player = videojs("modal_video_player", {controls: false}, function() {
				$j("#modal_video_player_container").show();
				VPB.durationSelector.init();
				VPB.positionSelector.init();
				VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
				$(this).on("timeupdate", function (e) {
					VPB.positionSelector.updateTimePosition(VPB.modalVideoPlayer.player.currentTime());
					$j("#duration_position").html(VPB.durationSelector.convert(Math.round(VPB.modalVideoPlayer.player.currentTime())));

					if (VPB.modalVideoPlayer.player.currentTime() >= VPB.SectionTimeData[VPB.currentSection].stop) {
						VPB.modalVideoPlayer.pause();
						if (VPB.SectionTimeData[VPB.currentSection].stop != VPB.SectionTimeData[VPB.currentSection].start) {
							VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
						}
						$j("#duration_play").show();
						$j("#duration_pause").hide();
					}
					else if (VPB.modalVideoPlayer.player.ended()) {
						$j("#duration_play").show();
						$j("#duration_pause").hide();
						if (VPB.SectionTimeData[VPB.currentSection].stop != VPB.SectionTimeData[VPB.currentSection].start) {
							VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
						}
					}
				});
				$j("#duration_play").on("click", function () {
					VPB.modalVideoPlayer.play();
					$j(this).hide();
					$j("#duration_pause").show();
				});
				$j("#duration_pause").on("click", function () {
					VPB.modalVideoPlayer.pause();
					$j(this).hide();
					$j("#duration_play").show();
				});
			});
		},
		init:function(){
		}
	},
	// initialize page
	init:function() {
		VPB.sharingModal.init();
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
		}

		// focus on login form
		$j('#user_email').focus();
	}
};


// kaltura player callback
// This is the first call the flash player will make when it's loaded.
function jsCallbackReady () {

	// wire up video player listeners
	VPB.videoPlayer.player.addJsListener("playerStateChange", "VPB.videoPlayer.changeListener");
	VPB.videoPlayer.player.addJsListener("kdpReady", "VPB.videoPlayer.changeListener");
	VPB.videoPlayer.player.addJsListener("playerUpdatePlayhead", "VPB.videoPlayer.handlePlayerUpdatePlayhead");

	// this is when the player is actually ready for scripting
	VPB.videoPlayer.player.addJsListener("bytesDownloadedChange", "VPB.videoPlayer.handlePlayerReady");

	VPB.videoPlayer.player.addJsListener("scrubberDragEnd", "VPB.videoPlayer.handleScrubberDragEnd");
	VPB.videoPlayer.player.addJsListener("playerSeekEnd", "VPB.videoPlayer.handlePlayerSeekEnd");
}

$j(document).ready(VPB.init);
