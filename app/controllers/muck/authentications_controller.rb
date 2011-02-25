class Muck::AuthenticationsController < ApplicationController
  def index
    @current_authentications = current_user.authentications if current_user
    @unused_authentications = get_unused_authentications(@current_authentications)    
    respond_to do |format|
      format.html { render :template => 'authentications/index' }
    end
  end
  
  def create
    @omniauth = request.env["omniauth.auth"]
    # Associated the account with the user
    if current_user
      @user = current_user
      current_user.authentications.create!(:provider => @omniauth['provider'], :uid => @omniauth['uid'], :raw_auth => @omniauth.to_json, 
                                           :token => @omniauth['credentials']['token'], :secret => @omniauth['credentials']['secret'] )
      flash[:notice] = t('muck.auth.authentication_success')
      status = :logged_in_success
    elsif authentication = Authentication.find_by_provider_and_uid(@omniauth['provider'], @omniauth['uid']) # Try to log the user in via the service
      flash[:notice] = t('muck.users.login_success')
      UserSession.create(authentication.user)
      @user = current_user
      status = :log_via_oauth_in_success      
    else
      # Could not find any information. Create a new account.
      @user = User.new
      @user.apply_omniauth(@omniauth)
      @user.generate_password
      if @user.save
        UserSession.create(@user)
        flash[:notice] = t('muck.users.thanks_sign_up')
        status = :new_signup_success 
      else
        # Have to build a new user to get rid of the password
        @user = User.new
        @user.apply_omniauth(@omniauth)
        status = :new_signup_failure
      end
    end
    after_create_response(status)
  end
  
  def failure
    respond_to do |format|
      format.html { render :template => 'authentications/failure' }
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    @current_authentications = current_user.authentications
    @unused_authentications = get_unused_authentications(@current_authentications)
    after_destroy_response
  end
  
  protected
  
    def get_unused_authentications(current_authentications)
      if current_authentications
        Authentication.unused_services(current_authentications)
      else
        Authentication.all_services 
      end
    end
    
    def after_destroy_response
      respond_to do |format|
        format.html do
          flash[:notice] = t('muck.auth.removed_authentication')
          redirect_to authentications_url
        end
        format.js { render :template => 'authentications/destroy' }
      end
    end
    
    def after_create_response(status)
      case status
        when :logged_in_success 
          redirect_to authentications_url
        when :log_via_oauth_in_success 
          redirect_to authentications_url
        when :new_signup_success 
          signup_complete_path(@user)
        when :new_signup_failure
          render :template => 'authentications/signup'
      end
    end
  
end
