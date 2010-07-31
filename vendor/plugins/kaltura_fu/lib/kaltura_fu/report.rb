module KalturaFu
  class << self
    def generate_report(from_date,video_list)
      hash_array = []
            
      self.check_for_client_session
      
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
      
      self.check_for_client_session
      
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
      
      self.check_for_client_session
      
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
      
      self.check_for_client_session
      
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
  end
end