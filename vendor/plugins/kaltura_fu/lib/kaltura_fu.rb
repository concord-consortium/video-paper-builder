require 'kaltura_fu/video'
require 'kaltura_fu/category'
require 'kaltura_fu/report'

class Hash
  def recursively_symbolize_keys
    tmp = {}
    for k, v in self
      tmp[k] = if v.respond_to? :recursively_symbolize_keys
                 v.recursively_symbolize_keys
               else
                 v
               end
    end
    tmp.symbolize_keys
  end
end

module KalturaFu
  
  @@config = {}
  @@client = nil
  @@client_configuration = nil
  @@session_key = nil
  mattr_reader :config
  mattr_reader :client
  mattr_reader :session_key
  
  #@@config[:partner_id] = kaltura['partner_id']


  class << self
    
    def config=(options)
      @@config = options
    end
    def create_client_config
      @@client_configuration = Kaltura::Configuration.new(@@config[:partner_id])
      unless @@config[:service_url].blank?
        @@client_configuration.service_url = @@config[:service_url]
      end
      @@client_configuration
    end
    
    def create_client
      if @@client_configuration.nil?
        self.create_client_config
      end
      @@client = Kaltura::Client.new(@@client_configuration)
      @@client
    end
    
    def generate_session_key
      self.check_for_client_session
      
      @@session_key = @@client.session_service.start(@@config[:administrator_secret],'',Kaltura::Constants::SessionType::ADMIN)
      @@client.ks = @@session_key
    end
    
    def clear_session_key!
      @@session_key = nil
    end
    
    def check_for_client_session
      if @@client.nil?
        self.create_client
        self.generate_session_key
        true
      else
        true
      end
    end
          
  end
end
