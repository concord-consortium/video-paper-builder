require 'fileutils'
CONFIG = File.join Rails.root, "config"
PUBLIC = File.join Rails.root, "public"
JS = File.join PUBLIC, "javascripts"
KALTURA_FU_PATH = File.join Rails.root, "vendor","plugins", "kaltura_fu"

namespace :kaltura_fu do
  
  namespace :install do
    
    desc 'Install the Kaltura Config File'
    task :config do
      config_file = File.join(KALTURA_FU_PATH,"config","kaltura.yml")
      
      existing_config_file = File.join(CONFIG,"kaltura.yml")
      unless File.exists?(existing_config_file)
        FileUtils.cp_r config_file, CONFIG 
        puts "Config File Loaded"
      else
        puts "Config File Already Exists"
      end
    end
    
    task :js do
      source_js_file = File.join(KALTURA_FU_PATH,"javascripts","kaltura_upload.js")
      target_js_file = File.join(JS,"kaltura_upload.js")
      
      unless File.exists?(target_js_file)
        FileUtils.cp_r source_js_file, JS
        puts "JS Files Loaded"
      else
        puts "JS Files already exist"
      end
    end
    
    task :all => ['kaltura_fu:install:config','kaltura_fu:install:js'] do
      puts "Kaltura Fu has been installed!"
      puts "---"
    end
    
  end
  
end

