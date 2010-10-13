require 'omniauth/oauth'

require 'muck-auth/config'
require 'muck-auth/engine'

MuckAuth.configuration.oauth_credentials.each_key do |key|
  use OmniAuth::Builder do
    provider key, MuckAuth.configuration.credentials[key][:key], MuckAuth.configuration.credentials[key][:secret]
  end
end