require File.dirname(__FILE__) + '/spec_helper'

describe KalturaFu, :type => :helper do 

  it "should have the proper javascript include tags" do
    html = helper.include_kaltura_fu
    
    html.should have_tag("script[src= ?]", 
			 "http://ajax.googleapis.com/ajax/libs/swfobject" + 
			 "/2.2/swfobject.js" )

    html.should have_tag("script[src = ?]",
			 %r{/javascripts/kaltura_upload.js\?[0-9]*})    
  end

  it "should create a plain thumbnail" do
    html = helper.kaltura_thumbnail(12345)


    if KalturaFu.config[:thumb_width] && KalturaFu.config[:thumb_height]
      html.should have_tag("img[src = ?]" , "http://www.kaltura.com/p/" + 
			   KalturaFu.config[:partner_id] + 
			   "/thumbnail/entry_id/12345" + "/width/" + 
			   KalturaFu.config[:thumb_width] + "/height/" + 
			   KalturaFu.config[:thumb_height])
    else
      html.should have_tag("img[src = ?]", 
			   "http://www.kaltura.com/p/" + 
			   KalturaFu.config[:partner_id] +
			   "/thumbnail/entry_id/12345")
    end
  end
  it "should create an appropriately sized thumbnail" do
    html = helper.kaltura_thumbnail(12345,:size=>[800,600])

    html.should have_tag("img[src = ?]", "http://www.kaltura.com/p/" +
			 KalturaFu.config[:partner_id] +
			 "/thumbnail/entry_id/12345" + "/width/800" +
			 "/height/600")
  end
  it "should create a thumbnail at the right second" do
    html = helper.kaltura_thumbnail(12345,:size=>[800,600],:second=> 6)

    html.should have_tag("img[src = ?]", "http://www.kaltura.com/p/" +
			 KalturaFu.config[:partner_id] +
			 "/thumbnail/entry_id/12345" + "/vid_sec/6" +
			 "/width/800/height/600")
  end
  it "should embed a default player" do
    html = helper.kaltura_player_embed(12345)

    #check the outer div
    html.should have_tag("div#kplayer")

    # check the parameters
    html.should have_tag("script",%r{allowscriptaccess: "always"})
    html.should have_tag("script",%r{allownetworking: "all"})
    html.should have_tag("script",%r{allowfullscreen: "true"})
    html.should have_tag("script",%r{wmode: "opaque"})

    # check the vars
    html.should have_tag("script",%r{entryId: "12345"})  

    # check the embed
    html.should have_tag("script",%r{swfobject.embedSWF})
    html.should have_tag("script",
      %r{http://www.kaltura.com/kwidget/wid/_#{KalturaFu.config[:partner_id]}})
    if KalturaFu.config[:player_conf_id]
      html.should have_tag("script",
        %r{/ui_conf_id/#{KalturaFu.config[:player_conf_id]}})
    else 
      html.should have_tag("script",
	%r{/ui_conf_id/#{KalturaFu::ViewHelpers::DEFAULT_KPLAYER}})
    end
    html.should have_tag("script",%r{"kplayer","400","330"})
  end
  it "should embed a player with a different div" do
    html = helper.kaltura_player_embed(12345,:div_id=>"waffles")

    #check the outer div
    html.should have_tag("div#waffles")

    # check the parameters
    html.should have_tag("script",%r{allowscriptaccess: "always"})
    html.should have_tag("script",%r{allownetworking: "all"})
    html.should have_tag("script",%r{allowfullscreen: "true"})
    html.should have_tag("script",%r{wmode: "opaque"})

    # check the vars
    html.should have_tag("script",%r{entryId: "12345"})  

    # check the embed
    html.should have_tag("script",%r{swfobject.embedSWF})
    html.should have_tag("script",
      %r{http://www.kaltura.com/kwidget/wid/_#{KalturaFu.config[:partner_id]}})
    if KalturaFu.config[:player_conf_id]
      html.should have_tag("script",
        %r{/ui_conf_id/#{KalturaFu.config[:player_conf_id]}})
    else
      html.should have_tag("script",
	%r{/ui_conf_id/#{KalturaFu::ViewHelpers::DEFAULT_KPLAYER}})
    end
    html.should have_tag("script",%r{"waffles","400","330"})
  end 

  it "should embed a player with a different config id" do
    html = helper.kaltura_player_embed(12345, :player_conf_id=>"1234")

    #check the outer div
    html.should have_tag("div#kplayer")

    # check the parameters
    html.should have_tag("script",%r{allowscriptaccess: "always"})
    html.should have_tag("script",%r{allownetworking: "all"})
    html.should have_tag("script",%r{allowfullscreen: "true"})
    html.should have_tag("script",%r{wmode: "opaque"})

    # check the vars
    html.should have_tag("script",%r{entryId: "12345"})  

    # check the embed
    html.should have_tag("script",%r{swfobject.embedSWF})
    html.should have_tag("script",
      %r{http://www.kaltura.com/kwidget/wid/_#{KalturaFu.config[:partner_id]}})
    html.should have_tag("script",
      %r{/ui_conf_id/1234})
    html.should have_tag("script",%r{"kplayer","400","330"})
  end 

  it "should allow a resize on the player" do
    html = helper.kaltura_player_embed(12345,:size=>[200,170])

    #check the outer div
    html.should have_tag("div#kplayer")

    # check the parameters
    html.should have_tag("script",%r{allowscriptaccess: "always"})
    html.should have_tag("script",%r{allownetworking: "all"})
    html.should have_tag("script",%r{allowfullscreen: "true"})
    html.should have_tag("script",%r{wmode: "opaque"})

    # check the vars
    html.should have_tag("script",%r{entryId: "12345"})  

    # check the embed
    html.should have_tag("script",%r{swfobject.embedSWF})
    html.should have_tag("script",
      %r{http://www.kaltura.com/kwidget/wid/_#{KalturaFu.config[:partner_id]}})
    if KalturaFu.config[:player_conf_id]
      html.should have_tag("script",
        %r{/ui_conf_id/#{KalturaFu.config[:player_conf_id]}})
    else 
      html.should have_tag("script",
	%r{/ui_conf_id/#{KalturaFu::ViewHelpers::DEFAULT_KPLAYER}})
    end
    html.should have_tag("script",%r{"kplayer","200","170"})
  end
  
  it "should seek to a time in seconds when asked" do
    html = helper.kaltura_seek_link("Seek to 5 seconds","5")
    html.should have_tag("a[href=\"#\"]", "Seek to 5 seconds")
    html.should have_tag("a[onclick=\"$(kplayer).get(0).sendNotification(\'doSeek\',5);window.scrollTo(0,0);return false;\"]")
    html.should_not have_tag("a[div_id=\"kplayer\"]")
  end

end
