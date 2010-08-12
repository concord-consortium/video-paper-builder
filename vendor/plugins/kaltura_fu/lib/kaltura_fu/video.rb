module KalturaFu
  class << self
    def get_video_info(video_id)  
      self.check_for_client_session
      
      response = self.video_exists?(video_id)
      raise "ID: #{video_id} Not found!" unless response
      response
    end
    
    def video_exists?(video_id)
      self.check_for_client_session
      
      begin
        response = @@client.media_service.get(video_id)
      rescue Kaltura::APIError => e
        response = nil
      end
      if response.nil?
        false
      else
        response
      end
    end
    
    def set_video_description(video_id,description)
      self.check_for_client_session
      
      if self.video_exists?(video_id)
        new_entry = Kaltura::MediaEntry.new
        new_entry.description = description
        @@client.media_service.update(video_id,new_entry)
        true
      else
        false
      end
    end
    
    def check_video_status(video_id)
      self.check_for_client_session
      
      video_status = self.get_video_info(video_id).status
      if video_status == Kaltura::Constants::Entry::Status::READY
        video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
        error_count = 0
        not_ready_count = 0
        ready_count = 0
        video_array.each do |video|
          case video.status
            when Kaltura::Constants::FlavorAssetStatus::READY ||  Kaltura::Constants::FlavorAssetStatus::DELETED || Kaltura::Constants::FlavorAssetStatus::NOT_APPLICABLE
              ready_count +=1
            when Kaltura::Constants::FlavorAssetStatus::ERROR
              error_count +=1
            when Kaltura::Constants::FlavorAssetStatus::QUEUED || Kaltura::Constants::FlavorAssetStatus::CONVERTING
              not_ready_count +=1
          end
        end
        #puts "errors: #{error_count} ready:#{ready_count} not_ready:#{not_ready_count} total:#{video_array.size} \n"
        if error_count > 0
          Kaltura::Constants::FlavorAssetStatus::ERROR
        elsif not_ready_count > 0
          Kaltura::Constants::FlavorAssetStatus::CONVERTING
        else
          Kaltura::Constants::FlavorAssetStatus::READY
        end
      else
        video_status
      end
    end
    
    def get_original_file_extension(video_id)
      self.check_for_client_session
    
      video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
      source_extension = nil
      video_array.each do |video|
        if video.is_original
          source_extension = video.file_ext
        end
      end
      source_extension
    end
    def get_thumbnail(video_id,time=nil)
      if time.nil?
        "http://www.kaltura.com/p/#{@@config[:partner_id]}" + "/thumbnail/entry_id/#{video_id}/width/545"
      else
        "http://www.kaltura.com/p/#{@@config[:partner_id]}" + "/thumbnail/entry_id/#{video_id}/width/545/vid_sec/#{time}"
      end
    end
    
    def generate_embed_script(options={})
      options[:autoplay] ||= 'false'
      if options[:autoplay] != 'true'
        options[:autoplay] = 'false'
      end
      options[:player_type] ||= 'simple'
      options[:width] ||= '437'
      options[:height] ||= '288'
      
      "<object name=\"kaltura_player\" id=\"kaltura_player\" type=\"application/x-shockwave-flash\""+
      " allowScriptAccess=\"always\" allowNetworking=\"all\" allowFullScreen=\"true\" "+
      "height=\"#{options[:height]}\" width=\"#{options[:width]}\" "+
      "data=\"http://www.kaltura.com/index.php/kwidget/wid/0_hncuf88s/uiconf_id/1674262\">"+
      "<param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowNetworking\" value=\"all\" />"+
      "<param name=\"allowFullScreen\" value=\"true\" /><param name=\"bgcolor\" value=\"#000000\" />"+
      "<param name=\"movie\" value=\"http://www.kaltura.com/index.php/kwidget/wid/0_hncuf88s/uiconf_id/1674262\"/>"+
      "<param name=\"flashVars\" value=\"autoPlay=#{options[:autoplay]}\"/><a href=\"http://ttv.mit.edu\">MIT Tech TV</a></object>"
    end
  end
end