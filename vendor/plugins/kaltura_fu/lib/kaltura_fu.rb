class Hash
  def recursively_symbolize_keys
    tmp = {}
    for k, v in self
      tmp[k] = if v.respond_to? :recursively_symbolize_keys
                 v.recursively_symbolize_keys
               else
                 v
               end
    end
    tmp.symbolize_keys
  end
end

module KalturaFu
  @@config = {}
  @@client = nil
  @@client_configuration = nil
  @@session_key = nil
  mattr_reader :config
  mattr_reader :client
  mattr_reader :session_key
  
  #@@config[:partner_id] = kaltura['partner_id']


  class << self
    def config=(options)
      @@config = options
    end
    def create_client_config
      @@client_configuration = Kaltura::Configuration.new(@@config[:partner_id])
      unless @@config[:service_url].blank?
        @@client_configuration.service_url = @@config[:service_url]
      end
      @@client_configuration
    end
    
    def create_client
      if @@client_configuration.nil?
        self.create_client_config
      end
      @@client = Kaltura::Client.new(@@client_configuration)
      @@client
    end
    
    def generate_session_key
      if @@client.nil?
        self.create_client
      end
      @@session_key = @@client.session_service.start(@@config[:administrator_secret],'',Kaltura::Constants::SessionType::ADMIN)
      @@client.ks = @@session_key
    end
    
    def clear_session_key!
      @@session_key = nil
    end

    def get_video_info(video_id)  
      if @@client.nil?
        self.generate_session_key
      end
      response = @@client.media_service.get(video_id)
      raise "ID Not found!" if response.nil?
      response
    end
    
    def check_video_status(video_id)
      if @@client.nil?
        self.generate_session_key
      end
      
      video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
      status = Kaltura::Constants::FlavorAssetStatus::ERROR
      video_array.each do |video|
        status = video.status
        if video.status != Kaltura::Constants::FlavorAssetStatus::READY
          if video.status == Kaltura::Constants::FlavorAssetStatus::NOT_APPLICABLE
            status = Kaltura::Constants::FlavorAssetStatus::READY
          else
            break
          end
        end
      end
      status
    end
    
    def get_original_file_extension(video_id)
      if @@client.nil?
        self.generate_session_key
      end
    
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
    
    def generate_report(from_date,video_list)
      hash_array = []
            
      if @@client.nil?
        self.generate_session_key
      end
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i
      report_pager = Kaltura::FilterPager.new
      report_pager.page_size = 1000
      
      report_raw = @@client.report_service.get_table(Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                     report_filter,
                                                     report_pager,
                                                     Kaltura::Constants::Media::OrderBy::PLAYS_DESC,
                                                     video_list)
      report_split_by_entry = report_raw.data.split(";")
      report_split_by_entry.each do |row|
        segment = row.split(",")
        row_hash = {}
        row_hash[:entry_id] = segment.at(0)
        row_hash[:plays] = segment.at(2)
        row_hash[:play_through_25] = segment.at(3)
        row_hash[:play_through_50] = segment.at(4)
        row_hash[:play_through_75] = segment.at(5)
        row_hash[:play_through_100] = segment.at(6)
        hash_array << row_hash
      end
      
      hash_array = hash_array.sort{|a,b| b[:plays].to_i <=> a[:plays].to_i}
      
      hash_array                                              
    end
    
    def generate_report_total(from_date,video_list)
      row_hash = {}
      
      if @@client.nil?
        self.generate_session_key
      end
      
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i      
      report_raw = @@client.report_service.get_total(Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                     report_filter,
                                                     video_list)
      segment = report_raw.data.split(",")
      row_hash[:plays] = segment.at(0)
      row_hash[:play_through_25] = segment.at(1)
      row_hash[:play_through_50] = segment.at(2)
      row_hash[:play_through_75] = segment.at(3)
      row_hash[:play_through_100] = segment.at(4)                                         
      row_hash
    end
    
    def generate_report_video_count(from_date,video_list)
      row_hash = {}
      
      if @@client.nil?
        self.generate_session_key
      end
      
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i
      report_pager = Kaltura::FilterPager.new
      report_pager.page_size = 1000
      
      report_raw = @@client.report_service.get_table(Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                     report_filter,
                                                     report_pager,
                                                     Kaltura::Constants::Media::OrderBy::PLAYS_DESC,
                                                     video_list)
      segment = report_raw.data.split(",")
      row_hash[:plays] = segment.at(0)
      row_hash[:play_through_25] = segment.at(1)
      row_hash[:play_through_50] = segment.at(2)
      row_hash[:play_through_75] = segment.at(3)
      row_hash[:play_through_100] = segment.at(4)                                         
      #row_hash
      report_raw.total_count
    end
    
    def generate_report_csv_url(from_date,video_list)
      report_title = "TTV Video Report"
      report_text = "I'm not sure what this is"
      headers = "Kaltura Entry,Plays,25% Play-through,50% Play-through, 75% Play-through, 100% Play-through, Play-Through Ratio"
      
      if @@client.nil?
        self.generate_session_key
      end
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i
      report_pager = Kaltura::FilterPager.new
      report_pager.page_size = 1000
      
      report_url = @@client.report_service.get_url_for_report_as_csv(report_title,
                                                                     report_text,
                                                                     headers,
                                                                     Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                                     report_filter,
                                                                     "",
                                                                     report_pager,
                                                                     Kaltura::Constants::Media::OrderBy::PLAYS_DESC,
                                                                     video_list)
      report_url      
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
