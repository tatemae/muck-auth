require 'rails'
require 'omniauth/oauth'
require 'muck-auth'

module MuckAuth
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-auth'
    end
    
    initializer 'muck_auth.helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include MuckAuthHelper
      end
    end
    
    initializer 'muck_auth.i18n' do |app|
      ActiveSupport.on_load(:i18n) do
        I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', '..', 'config', 'locales', '*.{rb,yml}') ]
      end
    end

    initializer "muck_auth.add_middleware" do |app|
      raise MuckAuth::Exceptions::InvalidConfiguration, "Please provide a valid configuration for Muck Auth." if Secrets.auth_credentials.blank?
      
      Secrets.auth_credentials.each_key do |provider|
        Rails.application.config.middleware.use OmniAuth::Builder do
          provider(provider, Secrets.auth_credentials[provider]['key'], Secrets.auth_credentials[provider]['secret'], :scope => Secrets.auth_credentials[provider]['scope'])
        end  
      end      
    end
       
  end
end