var flashObj;
var delegate = {};
var mediaTypeInput;

//KSU handlers
delegate.readyHandler = function()
{	
	flashObj = document.getElementById("uploader");
}

delegate.selectHandler = function()
{	
	//flashObj.upload();
	//console.log("selectHandler()");		
	//console.log(flashObj.getTotalSize());
}

function setMediaType()
{
	var mediaType = document.getElementById("mediaTypeInput").value; 
	//alert(mediaType);
	//console.log(mediaType);
	flashObj.setMediaType(mediaType);
}

delegate.singleUploadCompleteHandler = function(args)
{
	
	flashObj.addEntries();
	//console.log("singleUploadCompleteHandler", args[0].title);
	document.getElementById('button_submit').disabled = false;
	
}

delegate.allUploadsCompleteHandler = function()
{
	//console.log("allUploadsCompleteHandler");
}

delegate.entriesAddedHandler = function(entries)
{
	//alert(entries.length);
	var entry = entries[0];
	//alert(entry.entryId);
	document.getElementById('video_entry_id').value = entry.entryId
	//console.log(entries);
}

delegate.progressHandler = function(args)
{	
	document.getElementById('video_title').value = args[2].title;
	var bob = Math.round(args[0] / args[1] * 100);	
	document.getElementById('progress').value = bob;
	//console.log(args[2].title + ": " + args[0] + " / " + args[1]);
}

delegate.uiConfErrorHandler = function()
{
	console.log("ui conf loading error");
}

<!--- JavaScript callback methods to activate Kaltura services via the KSU widget.-->
function upload()
{
	flashObj.upload();
	//flashObj.addEntries();
}