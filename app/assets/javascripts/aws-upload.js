$j(document).ready(function() {

  // skip if no uploader form
  if ($j(".create_video").length === 0) {
    return;
  }

  $j('#thumbnail-time-code-show').click(function(){
    $j('#thumbnail-image').hide();
    $j('#thumbnail-time-code').show();
  });
  $j('#thumbnail-file-show').click(function(){
    $j('#thumbnail-image').show();
    $j('#thumbnail-time-code').hide();
  });

  var $s3Uploader = $j('#s3-uploader');
  $s3Uploader.S3Uploader({
    remove_completed_progress_bar: false,
    remove_failed_progress_bar: true,
    before_add: function (file) {
      // TODO: potentially check extension on file.name for valid video types - return false if not supported
      return true;
    }
  });
  $s3Uploader.bind('s3_uploads_start', function (e) {
    enableUploadButton(false);
    $j("button_disabled_video_uploading").show();
    $j('#button_disabled_no_video').hide();
  });
  $s3Uploader.bind('s3_upload_complete', function (e, content) {
    $j("button_disabled_video_uploading").hide();
    $j("#video-selected").show();
    $j("#title-text").html(content.filename);
    $j("#video_filename").html(content.filename);
    $j("input[name='video[upload_uri]']").val(content.url);
    $j('#upload-complete').show();
    $j('.file_select').hide();
    enableUploadButton(true);
  });
  $s3Uploader.bind('s3_upload_failed', function (e, content) {
    alert('Sorry, the upload of the video failed.');
    $j("button_disabled_video_uploading").hide();
    enableUploadButton(false);
  });
  $j("#change-video").click(function () {
    $j("#video-selected").hide();
    $j('.file_select').show();
    return false;
  });

  function enableUploadButton(enable) {
    $j("#button_submit").attr("disabled", !enable);
  }
});
