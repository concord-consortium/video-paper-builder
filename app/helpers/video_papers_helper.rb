module VideoPapersHelper

  ##
  # gets the paperclip thumbnail if it's there, otherwise uses kaltura.
  #
  def get_video_paper_thumbnail(video_paper)
    unless video_paper.video.nil?
      if video_paper.video.thumbnail?
        image_tag(video_paper.video.thumbnail.url)
      else
        kaltura_thumbnail(video_paper.video.entry_id,:size=>[150,150])
      end
    else
      "no video"
    end
  end

  def edit_section_link(args)
    video_paper = args[:video_paper]
    section = args[:section]
    text = args[:text]
    return "<a href=\"#{video_paper.id}/edit_section?section=#{section}\" title=\"Edit #{section} Section\">#{text} #{section}</a>"
  end
end
