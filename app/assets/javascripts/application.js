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
		slider: null,
		convert:function(time) {
			hours = parseInt( time / 3600 ) % 24;
			minutes = parseInt( time / 60 ) % 60;
			seconds = time % 60;
			result = (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds  < 10 ? "0" + seconds : seconds);
			return result;
		},
		parse:function(time) {
			var parts = time.split(':'),
					hours = parseInt(parts[0] || "", 10),
					mins = parseInt(parts[1] || "", 10),
					secs = parseInt(parts[2] || "", 10);
			if ((parts.length != 3) || isNaN(hours) || isNaN(mins) || isNaN(secs)) {
				return -1;
			}
			return (hours * 60 * 60) + (mins * 60) + secs;
		},
		prevStart:undefined,
		prevStop:undefined,
		handleSlide:function(event, ui) {
			VPB.SectionTimeData[VPB.currentSection].start = ui.values[0];
			VPB.SectionTimeData[VPB.currentSection].stop = ui.values[1];
			$j('#section_video_start_time').val(VPB.durationSelector.convert(ui.values[0]));
			$j('#section_video_stop_time').val(VPB.durationSelector.convert(ui.values[1]));
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
		handleTimeInput:function(when, time) {
			var offset = VPB.durationSelector.parse(time);
			if (offset != -1) {
				VPB.SectionTimeData[VPB.currentSection][when] = offset;
				VPB.durationSelector.slider.slider("values", when == "start" ? 0 : 1, offset);
				VPB.positionSelector.reset();
			}
		},
		init: function() {
		  VPB.currentSection = VPB.sectionTabs.selectInitialTab();
		  if(VPB.currentSection === 'undefined') { return; }
			// make sure we have time data to work with
			if(!VPB.SectionTimeData) { return; }
			// configure slider
			VPB.durationSelector.slider = $j('#duration_slider').slider({
				range: true,
				min:0,
				max:VPB.SectionTimeData[VPB.currentSection].length,
				values:[VPB.SectionTimeData[VPB.currentSection].start,VPB.SectionTimeData[VPB.currentSection].stop],
				slide:VPB.durationSelector.handleSlide,
				stop:VPB.durationSelector.handleStop
			});
			$j('#section_video_start_time').on("keyup", function (e) {
				VPB.durationSelector.handleTimeInput("start", e.target.value);
			});
			$j('#section_video_stop_time').on("keyup", function (e) {
				VPB.durationSelector.handleTimeInput("stop", e.target.value);
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

			VPB.sectionTabs.selectSection(tabIndex);

			return tabIndex;
		},
		// tab select callback handler
		activateCallback:function(event,ui) {
			VPB.sectionTabs.selectSection(ui.newTab.index());
			window.location.hash = ui.newPanel.selector;
		},
		selectSection: function(index) {
			var sectionTimeData = VPB.SectionTimeData && VPB.SectionTimeData[index] ? VPB.SectionTimeData[index] : null;

			VPB.currentSection = index;
			VPB.currentStart = sectionTimeData ? (sectionTimeData.start || 0) : 0;
			VPB.currentStop = sectionTimeData ? (sectionTimeData.stop || 0) : 0;
			if (sectionTimeData && VPB.videoPlayer) {
				VPB.videoPlayer.seek(sectionTimeData.start);
			}
		},
		sectionTabs:undefined,
		init:function() {
			// if we don't have section time data and tabs to work on, just stop.
			if( (! $j('#tabs').length) || !VPB.SectionTimeData) { return; }
			this.sectionTabs = $j("#tabs").tabs({
				selected:this.selectInitialTab(), // preselect tab
  			activate:this.activateCallback
			});
		}
	},
	sectionEditor:{
		changed: false,
		editing: false,
		tinyMceInit: function (editor) {
			editor.onClick.add(function () {
				VPB.sectionEditor.editing = true;
			});
			editor.onChange.add(function () {
				VPB.sectionEditor.changed = true;
			});
		},
		clearFlags: function() {
			VPB.sectionEditor.changed = false;
			VPB.sectionEditor.editing = false;
		},
		handleBeforeUnload:function(event) {
			if (VPB.sectionEditor.editing || VPB.sectionEditor.changed) {
				var message = 'Do you have any changes to section text to save before leaving this page?';
				event.returnValue = message;
				return message;
			}
		},
		handleCancel:function(event) {
			if (!VPB.sectionEditor.changed || confirm("Are you sure you want to cancel and lose your changes?")) {
				$j(event.target).parents().filter('.tab_content').addClass('view');
				$j(event.target).parents().filter('.tab_content').removeClass('edit');
				VPB.sectionEditor.clearFlags();
			}
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
		handleSave:function(event) {
			VPB.sectionEditor.clearFlags();
		},
		handleTabChange:function(e) {
			var changeTab = !VPB.sectionEditor.changed || confirm("Do you have any changes to save before leaving this section?  Click cancel to stay on the section you are editing.");
			if (changeTab) {
				VPB.sectionEditor.clearFlags();
				$j('.tab_content').each(function(idx,el) {
					$j(el).addClass('view');
					$j(el).removeClass('edit');
				});
			}
			else {
				e.preventDefault();
			}
		},
		init:function() {
			$j('.edit-button').click(this.handleEdit);
			$j('.cancel-button').click(this.handleCancel);
			$j("input[name='commit']").click(this.handleSave);
			// hook up modal popup to timing editor
			$j('.timing-button').fancybox(
				{
					modal:false,
					autoDimensions:false,
					overlayOpacity:.8,
					scrolling:'no',
					width:370,
					height:320,
					showCloseButton:true,
					enableEscapeButton:true,
					onStart: function () {
						VPB.videoPlayer.pause();
						if (!VPB.sectionEditor.changed || confirm("Are you sure you want to edit the timing without saving your section changes?")) {
							VPB.sectionEditor.clearFlags();
							VPB.modalVideoPlayer.init();
						}
						else {
							return false;
						}
					},
					onComplete: function () {
						$j(".modal_video_wrapper form").on("submit", function () {
							var startTime = $j("#section_video_start_time").val(),
							    stopTime = $j("#section_video_stop_time").val(),
									parsedStartTime = VPB.durationSelector.parse(startTime),
									parsedStopTime = VPB.durationSelector.parse(stopTime),
									validateTime = function (when, time) {
										var valid = VPB.durationSelector.parse(time) != -1;
										if (!valid) {
											alert("The " + when + " time is invalid - it must be in the form HH:MM:SS.")
										}
										return valid;
									};
							if (!validateTime("start", startTime) || !validateTime("stop", stopTime)) {
								return false;
							}
							if (parsedStartTime > parsedStopTime) {
								alert("The start time cannot be greater than the stop time");
								return false;
							}
							if (parsedStartTime > VPB.modalVideoPlayer.duration) {
								alert("The start time cannot be greater than the video duration");
								return false;
							}
							if (parsedStopTime > VPB.modalVideoPlayer.duration) {
								alert("The stop time cannot be greater than the video duration");
								return false;
							}
						});
						$j("#fancybox-close").on("click", function () {
							return confirm("Are you sure you want to close without saving?");
						});
					}
				}
			);

			$j(window).on("beforeunload", this.handleBeforeUnload);

			// listen for tab changes
			$j(document).bind('tabsbeforeactivate', this.handleTabChange);
		}
	},
	videoPlayer: {
		player:undefined,
		id:undefined,
		idIndex:1,
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
			if (this.player) {
				this.player.play();
				this.player.currentTime(offset);
				this.player.pause();
			}
		},
		show: function (video_url, thumbnail_url) {
			// video.js won't reuse video elements so we need to give it a new id each time
			VPB.videoPlayer.id = "video_player_" + VPB.videoPlayer.idIndex++;
			$j("#video_player_container").html([
				'<video id="', VPB.videoPlayer.id, '" class="video-js vjs-default-skin" controls preload="auto" width="360" height="202" poster="', thumbnail_url, '">',
					'<source src="', video_url, '" type="video/mp4" />',
				'</video>'
			].join(''));
			VPB.videoPlayer.player = videojs(VPB.videoPlayer.id, {}, function() {
				VPB.videoPlayer.seek(VPB.currentStart);
				$j("#transcoding_status").hide();
				$j("#video_player_container").show();

				$(this).on("timeupdate", function (e) {
					// Listen for when the player section is over and pause.
					if(VPB.videoPlayer.player.currentTime() > VPB.currentStop && VPB.currentStop !== 0) {
						VPB.videoPlayer.pause();
					}
				});
			});
		},
		init:function(){
		}
	},
	modalVideoPlayer: {
		player:undefined, // kdp handle
		id:undefined,
		idIndex:1,
		duration:0,
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
			if ((this.player) && (offset < VPB.modalVideoPlayer.duration)) {
				this.player.play();
				this.player.currentTime(offset);
				this.player.pause();
				$j("#duration_play").show();
				$j("#duration_pause").hide();
			}
		},
		seekSectionStart:function() {
			var stop = Math.round(VPB.SectionTimeData[VPB.currentSection].stop),
			    start = Math.round(VPB.SectionTimeData[VPB.currentSection].start);
			if ((stop != start) && (start < stop)) {
				VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
			}
		},
		show: function (video_url, thumbnail_url, duration) {
			VPB.modalVideoPlayer.duration = duration;
			// video.js won't reuse video elements so we need to give it a new id each time
			VPB.modalVideoPlayer.id = "modal_video_player_" + VPB.modalVideoPlayer.idIndex++;
			$j("#modal_video_player_container").html([
				'<video id="', VPB.modalVideoPlayer.id, '" class="video-js vjs-default-skin" controls preload="auto" width="350" height="197" poster="', thumbnail_url, '">',
					'<source src="', video_url, '" type="video/mp4" />',
				'</video>'
			].join(''));
			VPB.modalVideoPlayer.player = videojs(VPB.modalVideoPlayer.id, {controls: false}, function() {
				$j("#modal_video_player_container").show();
				VPB.durationSelector.init();
				VPB.positionSelector.init();
				VPB.modalVideoPlayer.seek(VPB.SectionTimeData[VPB.currentSection].start);
				$(this).on("timeupdate", function (e) {
					VPB.positionSelector.updateTimePosition(VPB.modalVideoPlayer.player.currentTime());
					$j("#duration_position").html(VPB.durationSelector.convert(Math.round(VPB.modalVideoPlayer.player.currentTime())));

					if (VPB.modalVideoPlayer.player.currentTime() > VPB.SectionTimeData[VPB.currentSection].stop) {
						VPB.modalVideoPlayer.pause();
						VPB.modalVideoPlayer.seekSectionStart();
						$j("#duration_play").show();
						$j("#duration_pause").hide();
					}
					else if (VPB.modalVideoPlayer.player.ended()) {
						VPB.modalVideoPlayer.seekSectionStart();
						$j("#duration_play").show();
						$j("#duration_pause").hide();
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

		// focus on login form
		$j('#user_email').focus();
	}
};

$j(document).ready(VPB.init);
