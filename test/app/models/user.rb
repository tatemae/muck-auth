class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  include MuckUsers::Models::MuckUser
  include MuckAuth::Models::MuckUser
  include MuckProfiles::Models::MuckUser
  include MuckServices::Models::MuckFeedParent
  include MuckServices::Models::MuckFeedOwner
end