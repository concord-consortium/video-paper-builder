module VideoPapersHelper

  ##
  # gets the paperclip thumbnail if it's there, otherwise uses kaltura.
  #
  def get_video_paper_thumbnail(video_paper)
    unless video_paper.video.nil?
      if video_paper.video.thumbnail?
        image_tag(video_paper.video.thumbnail.url(:thumb))
      else
        if video_paper.video.thumbnail_time.nil? || video_paper.video.thumbnail_time.blank?
          kaltura_thumbnail(video_paper.video.entry_id,:size=>[120,120])
        else
          kaltura_thumbnail(video_paper.video.entry_id,:size=>[120,120],:second=> video_paper.video.thumbnail_time)
        end
      end
    else
      "<div class=\"no-video\"></div>"
    end
  end

  def edit_section_link(args)
    video_paper = args[:video_paper]
    section = args[:section]
    text = args[:text]
    return "<a href=\"#{video_paper.id}/edit_section?section=#{section}\" title=\"Edit #{section} Section\">#{text} #{section}</a>"
  end
  
  def is_last?(counter)
    "last" if counter % 4 == 0
  end
  
  def pick_arrow(order_by_clause,options={})
    if options[:position] == "top"
      if params[:order_by] == order_by_clause
        image_tag('top_arrow_active.gif')
      else
        image_tag('top_arrow_normal.gif')
      end
    else
      if params[:order_by] == order_by_clause
        image_tag('bottom_arrow_active.gif')
      else
        if params[:order_by].nil? && order_by_clause == 'date_desc'
          image_tag('bottom_arrow_active.gif')
        else
          image_tag('bottom_arrow_normal.gif')
        end
      end
    end
  end
end
