kaltura_fu
--------------
**Homepage**: [http://www.velir.com](http://www.velir.com)
**Author**: [Patrick Robertson](mailto:patrick.robertson@velir.com)
**Copyright**: 2010
**License**: [MIT License](file:MIT-LICENSE)

About Kaltura
----------------
[Kaltura](http://kaltura.org/) is an open source video streaming service.

About kaltura_fu
------------------

kaltura_fu is a rails plugin that extends the basic functionality of the Kaltura ruby client and adds in some Rails view helpers to generate video players, thumbnails, and the uploader.

Installation:
-------------
Install the plugin with the command 
	script/plugin install git@github.com:patricksrobertson/kaltura_fu.git
Run 
	rake kaltura_fu:install:all
This will install the config/kaltura.yml file into your application's root directory and the kaltura_upload.js into the application's public/javascripts directory.  You may choose to run these commands instead:
	rake kaltura_fu:install:config
	rake kaltura_fu:install:js
	

Usage:
------
Kaltura_fu provides four ActionView helper methods presently:

* include_kaltura_fu
* kaltura_thumbnail(entry_id, options={})
* kaltura_player_embed(entry_id,options={})
* kaltura_upload_embed(options={})

include_kaltura_fu embeds the kaltura_upload.js into the header.

kaltura_thumbnail(entry_id, options={}) has the following parameters:

* entry_id - The Kaltura entry_id of which you want to display a thumbnail
* hash of options.  The supported options are:

	* :size=> Array of integers.  [width,height].  This can be defaulted in the config with thumb_width and thumb_height.
	* :second=> Integer.  Specify the second of the video to create the thumbnail with.
	
kaltura_player_embed(entry_id,options={}) has the following parameters:

* entry_id - The Kaltura entry_id that you want to display in the player.
* hash of options.  The supported options are:

	* :div_id=> String.  Specifies the div ID of the object that will be embeded.  Defaults to kplayer.
	* :player_conf_id=> String.  The configuration ID of the player to use.  This can be defaulted in the config with player_conf_id.
	
kaltura_upload_embed(options={}) has the following parameters:

* hash of options:  The supported options are:

	* none at this time.
	

To Do's
-------
* Buff the options for the upload script a bit more.  

Copyright (c) 2010 [Patrick Robertson](http://www.velir.com), released under the MIT license