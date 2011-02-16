# include MuckAuth::Models::MuckAuthentication
module MuckAuth
  module Models
    module MuckAuthentication
      extend ActiveSupport::Concern
    
      included do
        belongs_to :authenticatable, :polymorphic => true        
      end
      
      module ClassMethods
        
        def all_services
          services = []
          Secrets.auth_credentials.each_key{ |s| services << s }
          services
        end
        
        def unused_services(current_authentications)
          all_services.find_all{ |s| !current_authentications.any?{ |c| c.provider == s } }
        end
        
      end
    
    end 
  end
end