require 'oa-oauth'

require 'muck-auth/config'
require 'muck-auth/engine'

MuckAuth.configuration.credentials.each_key do |key|
  use "OmniAuth::Strategies::#{key.camelize}".constantize, MuckAuth.configuration.credentials[key][:key], MuckAuth.configuration.credentials[key][:secret]
end