require 'webdrivers'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

CapybaraInitializer.configure do |config|
  config.headless = ENV.fetch('HEADLESS', true) != 'false'
end
