module KalturaUtil
  def self.find_test_video_id
    #find a video with the category of "test" to eff with.
    #if this fails you need to make add the test category and add a video to it on the kaltura server
    # for somereason my test video got changed to a category of cucumber
    return @video_id if @video_id
    KalturaFu.generate_session_key
    temp_filter = Kaltura::Filter::BaseFilter.new
    pager = Kaltura::FilterPager.new
    pager.page_size = 100000
    test_video = KalturaFu.client.media_service.list(temp_filter,pager).objects.map!{|c| c if c.categories == 'cucumber'}.compact!.last
    @video_id = test_video.id
  end
end