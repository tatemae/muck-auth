class Authentication < ActiveRecord::Base
  include MuckAuth::Models::MuckAuthentication
end