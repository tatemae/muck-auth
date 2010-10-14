require 'rails'
require 'omniauth/oauth'
require 'muck-auth'

module MuckProfiles
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
      raise MuckAuth::Exceptions::InvalidConfiguration, "Please provide a valid configuration for Muck Auth." if MuckAuth.configuration.oauth_credentials.blank?
      MuckAuth.configuration.oauth_credentials.each_key do |key|
        app.middleware.use OmniAuth::Builder do
          provider key, MuckAuth.configuration.oauth_credentials[key]['key'], MuckAuth.configuration.oauth_credentials[key]['secret']
        end  
      end
    end
            
  end
end