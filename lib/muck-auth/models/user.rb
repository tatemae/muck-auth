# include MuckAuth::Models::MuckUser
module MuckAuth
  module Models
    module MuckUser
      extend ActiveSupport::Concern
    
      included do
        has_many :authentications, :as => :authenticatable, :dependent => :destroy
        accepts_nested_attributes_for :authentications, :allow_destroy => true
      end
      
      def apply_omniauth(omniauth)
        self.email = omniauth['user_info']['email'] if email.blank?
        authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :raw_auth => omniauth.to_json)
      end
      
      def password_required?
        (authentications.empty? || !password.blank?) && super
      end
      
    end 
  end
end