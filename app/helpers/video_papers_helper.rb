module VideoPapersHelper

  ##
  # gets the paperclip thumbnail if it's there, otherwise uses aws.
  #
  def get_video_paper_thumbnail(video_paper)
    unless video_paper.video.nil?
      if video_paper.video.thumbnail?
        image_tag(video_paper.video.thumbnail.url(:thumb), alt: "Thumbnail")
      else
        thumbnail_url = video_paper.video.generate_signed_thumbnail_url()
        if thumbnail_url
          "<img src='#{thumbnail_url}' onerror='this.src=\"#{image_path('blank_fallback.png')}\"' onabort='this.src=\"#{image_path('blank_fallback.png')}\"'/>".html_safe
        else
          "<div class=\"no-thumbnail\"></div>".html_safe
        end
      end
    else
      "<div class=\"no-video\"></div>".html_safe
    end
  end

  def get_video_paper_thumbnail_with_default(video_paper, default_img_url)
    unless video_paper.video.nil?
      if video_paper.video.thumbnail?
        image_tag(video_paper.video.thumbnail.url(:thumb), alt: "Thumbnail")
      else
        thumbnail_url = video_paper.video.generate_signed_thumbnail_url()
        if thumbnail_url
          "<object data='#{thumbnail_url}' type='image/png'>#{image_tag(default_img_url)}</object>".html_safe
        else
          image_tag(default_img_url)
        end
      end
    else
      image_tag(default_img_url)
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
