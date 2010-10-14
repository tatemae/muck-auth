# include MuckAuth::Models::MuckUser
module MuckAuth
  module Models
    module MuckUser
      extend ActiveSupport::Concern
    
      included do
        has_many :authentications
      end
      
    end 
  end
end