var flashObj;
var delegate = {};
var mediaTypeInput;

delegate.readyHandler = function()
{	
	flashObj = document.getElementById("uploader");
}

delegate.selectHandler = function()
{	
	document.getElementById("selected-title").style.display = "inline";
	kaltura_array = flashObj.getFiles();
	last_file = kaltura_array[(kaltura_array.length -1.0)]
	document.getElementById("title-text").innerHTML = last_file.title;
	flashObj.upload();
}

function setMediaType()
{
	var mediaType = document.getElementById("mediaTypeInput").value; 
	flashObj.setMediaType(mediaType);
  
}

delegate.singleUploadCompleteHandler = function(args)
{	
}

delegate.allUploadsCompleteHandler = function()
{
	flashObj.addEntries();
}

delegate.entriesAddedHandler = function(entries)
{
  var entry_index = entries.length - 1.0;
	var entry = entries[entry_index];
	document.getElementById('video_entry_id').value = entry.entryId;
  //document.getElementById('button_submit').style.display = "inline";
  document.getElementById('button_submit').disabled = false;  
}

delegate.progressHandler = function(args)
{
  document.getElementById('progressBar').style.display = "inline";
	var bob = Math.round(args[0] / args[1] * 100);	
  $("#progress").progressBar(bob);
}

delegate.uiConfErrorHandler = function()
{
}

function upload()
{
	flashObj.upload();
}
