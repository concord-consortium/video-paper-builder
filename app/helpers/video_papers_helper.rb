module VideoPapersHelper

  def edit_section_link(args)
    video_paper = args[:video_paper]
    section = args[:section]
    text = args[:text]
    return "<a href=\"#{video_paper.id}/edit_section?section=#{section}\" title=\"Edit #{section} Section\">#{text} #{section}</a>"
  end
end
