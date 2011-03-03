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
        self.email = omniauth['user_info']['email'] if self.email.blank?
        
        self.first_name = omniauth['user_info']['first_name'] if self.first_name.blank?
        self.last_name = omniauth['user_info']['last_name'] if self.last_name.blank?
        
        # In case first and last name weren't provided:
        names = User.parse_name(omniauth['user_info']['name'])
        self.first_name = names[0] if self.first_name.blank?
        self.last_name = names[1] if self.last_name.blank?
        
        self.login = omniauth['user_info']['nickname'] if self.login.blank?
        # Some providers don't provide a valid nickname so try the first name
        self.login = self.first_name if !self.valid? && self.errors[:login].any?
        
        self.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :raw_auth => omniauth.to_json,
                              :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'] )
                                             
      end
      
      def profile_from_omniauth(omniauth)
        if self.respond_to?(:profile)
          self.profile.location = omniauth['user_info']['location'] if self.profile.location.blank?
          self.profile.about = omniauth['user_info']['description'] if self.profile.about.blank?
          
          # TODO figure out how to get their profile image
          # self.profile.image = omniauth['user_info']['image'] if self.profile.image.blank?
        end
      end
      
      def feeds_from_omniauth(omniauth)
        uris = omniauth['user_info']['urls']
        return unless uris && defined?(Service)
        uris.each_pair do |name, uri|
          feeds = Feed.make_feeds_or_website(uri, self, name)
          feeds.compact!
          if !feeds.blank?
            feeds.each do |feed|
              self.own_feeds << feed
            end
          end
        end
      end
      
      def password_required?
        (authentications.empty? || !password.blank?) && super
      end
      
    end 
  end
end