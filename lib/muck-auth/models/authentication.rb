# include MuckAuth::Models::MuckAuthentication
module MuckAuth
  module Models
    module MuckAuthentication
      extend ActiveSupport::Concern
    
      included do
        belongs_to :user
      end
      
    end 
  end
end

