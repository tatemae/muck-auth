class Muck::AuthenticationsController < ApplicationController
  def index
    @current_authentications = current_user.authentications if current_user
    if @current_authentications
      @unused_authentications = Authentication.unused_services(@current_authentications)
    else
      @unused_authentications = Authentication.all_services 
    end
    respond_to do |format|
      format.html { render :template => 'authentications/index' }
    end
  end
  
  def create
    @omniauth = request.env["omniauth.auth"]
    # Associated the account with the user
    if current_user
      current_user.authentications.create!(:provider => @omniauth['provider'], :uid => @omniauth['uid'], :raw_auth => @omniauth.to_json, 
                                           :token => @omniauth['credentials']['token'], :secret => @omniauth['credentials']['secret'] )
      flash[:notice] = t('muck.auth.authentication_success')
      redirect_to authentications_url
    # Try to log the user in via the service
    elsif authentication = Authentication.find_by_provider_and_uid(@omniauth['provider'], @omniauth['uid'])
      flash[:notice] = t('muck.users.login_success')
      UserSession.create(authentication.user)
    # Could not find any information. Create a new account.
    else
      @user = User.new
      @user.apply_omniauth(@omniauth)
      @user.generate_password
      if @user.save
        UserSession.create(@user)
        flash[:notice] = t('muck.users.thanks_sign_up')
        signup_complete_path(@user)
      else
        # Have to build a new user to get rid of the password
        @user = User.new
        @user.apply_omniauth(@omniauth)
        render :template => 'authentications/signup'
      end
    end
  end
  
  def failure
    respond_to do |format|
      format.html { render :template => 'authentications/failure' }
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = t('muck.auth.removed_authentication')
    redirect_to authentications_url
  end
end
