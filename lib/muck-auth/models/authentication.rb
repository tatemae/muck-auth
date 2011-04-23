# include MuckAuth::Models::MuckAuthentication
module MuckAuth
  module Models
    module MuckAuthentication
      extend ActiveSupport::Concern
    
      included do
        belongs_to :authenticatable, :polymorphic => true        
      end
      
      def access_token
        access_token = OAuth::AccessToken.new(consumer, self.token, self.secret)        
      end
      
      def consumer
        strategy.consumer
      end
      
      def strategy
        strategy_class = OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(self.provider)}")
        strategy_class.new(nil, Secrets.auth_credentials[provider]['key'], Secrets.auth_credentials[provider]['secret'], :scope => Secrets.auth_credentials[provider]['scope'])
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