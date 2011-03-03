class Profile < ActiveRecord::Base
  include MuckProfiles::Models::MuckProfile
  has_friendly_id :login
  
end