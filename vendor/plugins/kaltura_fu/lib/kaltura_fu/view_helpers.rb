module KalturaFu
  module ViewHelpers

    DEFAULT_KPLAYER = '1339442'
    PLAYER_WIDTH = '400'
    PLAYER_HEIGHT = '330'
    
    def include_kaltura_fu(*args)
      content = javascript_include_tag('kaltura_upload')
      content << "\n#{javascript_include_tag('http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js')}" 
    end
    
    #returns a thumbnail image
    def kaltura_thumbnail(entry_id,options={})
      options[:size] ||= []
      size_parameters = ""
      seconds_parameter = ""
      
      unless options[:size].empty?
        size_parameters = "/width/#{options[:size].first}/height/" +
			  "#{options[:size].last}"
      else
        # if the thumbnail width and height are defined in the config,
	      # use it, assuming it wasn't locally overriden
        if KalturaFu.config[:thumb_width] && KalturaFu.config[:thumb_height]
          size_parameters = "/width/#{KalturaFu.config[:thumb_width]}/height/" +
			    "#{KalturaFu.config[:thumb_height]}"
        end
      end
      
      unless options[:second].nil?
        seconds_parameter = "/vid_sec/#{options[:second]}"
      end
      
      image_tag("http://www.kaltura.com/p/#{KalturaFu.config[:partner_id]}" +
		"/thumbnail/entry_id/#{entry_id}" + 
		seconds_parameter + 
		size_parameters)
    end
    
    #returns a kaltura player embed object
    def kaltura_player_embed(entry_id,options={})
      player_conf_parameter = "/ui_conf_id/"
      options[:div_id] ||= "kplayer"
      options[:size] ||= []
      options[:use_url] ||= false
      width = PLAYER_WIDTH
      height = PLAYER_HEIGHT
      source_type = "entryId"
      service_url = "http://www.kaltura.com"

      unless options[:size].empty?
	      width = options[:size].first
	      height = options[:size].last
      end
      
      if options[:use_url] == true
        source_type = "url"
      end
      
      unless KalturaFu.config[:service_url].nil?
        service_url = KalturaFu.config[:service_url]
      end
    
      unless options[:player_conf_id].nil?
        player_conf_parameter += "#{options[:player_conf_id]}"
      else
        unless KalturaFu.config[:player_conf_id].nil?
          player_conf_parameter += "#{KalturaFu.config[:player_conf_id]}"
	      else
	        player_conf_parameter += "#{DEFAULT_KPLAYER}"
        end
      end
      
      "<div id=\"#{options[:div_id]}\"></div>
      <script type=\"text/javascript\">
      	var params= {
      		allowscriptaccess: \"always\",
      		allownetworking: \"all\",
      		allowfullscreen: \"true\",
      		wmode: \"opaque\"
      	};
      	var flashVars = {
      		sourceType: \"#{source_type}\",      	  
      		entryId: \"#{entry_id}\",
      		emptyF: \"onKdpEmpty\",
      		readyF: \"onKdpReady\",
      	};
      	var attributes = {
          id: \"#{options[:div_id]}\",
          name: \"#{options[:div_id]}\"
      	};

      	swfobject.embedSWF(\"#{service_url}/kwidget/wid/_#{KalturaFu.config[:partner_id]}" + player_conf_parameter + "\",\"#{options[:div_id]}\",\"#{width}\",\"#{height}\",\"9.0.0\",false,flashVars,params,attributes);
      </script>"
    end
    
    def kaltura_upload_embed(options={})
      service_url = "http://www.kaltura.com"
            
      unless KalturaFu.config[:service_url].nil?
        service_url = KalturaFu.config[:service_url]
      end
      
      options[:div_id] ||="uploader"
      "<div id=\"#{options[:div_id]}\"></div>
    		<script type=\"text/javascript\">

    		var params = {
    			allowScriptAccess: \"always\",
    			allowNetworking: \"all\",
    			wmode: \"transparent\"
    		};
    		var attributes = {
    			id: \"uploader\",
    			name: \"KUpload\"
    		};
    		var flashVars = {
    			uid: \"ANONYMOUS\",
    			partnerId: \"#{KalturaFu.config[:partner_id]}\",
    			subPId: \"#{KalturaFu.config[:subpartner_id]}\",
    			entryId: \"-1\",
    			ks: \"#{KalturaFu.session_key}\",
    			uiConfId: '1000016',
    			jsDelegate: \"delegate\"
    		};

        swfobject.embedSWF(\"#{service_url}/kupload/ui_conf_id/1000016\", \"uploader\", \"160\", \"26\", \"9.0.0\", \"expressInstall.swf\", flashVars, params,attributes);
    	</script>"
    end
    
    def kaltura_contributor_embed(options={})
      service_url = "http://www.kaltura.com"
            
      unless KalturaFu.config[:service_url].nil?
        service_url = KalturaFu.config[:service_url]
      end
      
      options[:div_id] ||="uploader"
      "<div id=\"#{options[:div_id]}\"></div>
    		<script type=\"text/javascript\">

    		var params = {
    			allowScriptAccess: \"always\",
    			allowNetworking: \"all\",
    			wmode: \"opaque\"
    		};
    		var flashVars = {
    			uid: \"ANONYMOUS\",
    			partnerId: \"#{KalturaFu.config[:partner_id]}\",
    			ks: \"#{KalturaFu.session_key}\",
    			afterAddEntry: \"onConributionWizardAfterAddEntry\",
    			close: \"onContributionWizardClose\",
    			showCloseButton: \"false\",
    			Permissions: \"1\"
    		};

        swfobject.embedSWF(\"#{service_url}/kcw/ui_conf_id/1000740\", \"uploader\", \"680\", \"360\", \"9.0.0\", \"expressInstall.swf\", flashVars, params);

    	</script>"
    end
    
    def kaltura_seek_link(content,seek_time,options={})
      options[:div_id] ||= "kplayer"

      options[:onclick] = "$(#{options[:div_id]}).get(0).sendNotification('doSeek',#{seek_time});window.scrollTo(0,0);return false;"
      options.delete(:div_id)
      link_to(content,"#", options)
    end
  end
  
  
end
