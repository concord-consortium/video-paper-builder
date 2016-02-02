module HomeHelper
  def embed_help_video(video)
    return <<-html
    <div id="help_video_player_container">
      <video id="help_video_player" class="video-js vjs-default-skin" controls preload="auto" width="auto" height="auto">
        <source src="#{ENV['HELP_VIDEO_FOLDER_URL'] || '//models-resources.concord.org/vpb/help'}/#{video}.mp4" type="video/mp4" />',
      </video>
    </div>
    <script>
      videojs("help_video_player_container");
    </script>
    <noscript>Please enable Javascript.</noscript>
    html
  end
end
