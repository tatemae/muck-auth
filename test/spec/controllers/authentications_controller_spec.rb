require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::AuthenticationsController do

  render_views
  
  describe "GET index" do
    before(:each) do
      get :index
    end
    it { should respond_with :success }
    it { should render_template :index }
  end

  describe "GET failure" do
    before(:each) do
      get :failure
    end
    it { should respond_with :success }
    it { should render_template :failure }
  end
  
  # TODO need to find a way to mock and test the create process
  # describe "POST to create" do
  #   before(:each) do
  #     post :create, :authentication => { :email => Factory.next(:email) }
  #   end
  #   it { should redirect_to(access_code_request_path(assigns(:access_code_request))) }
  # end

  describe 'on DELETE to :destroy' do
    before(:each) do
      @user = Factory(:user)
      @controller.stub!(:current_user).and_return(@user)
      @authentication = Factory(:authentication, :authenticatable => @user)
      delete :destroy, {:id => @authentication.to_param}
    end
    it {should redirect_to(authentications_url)}
  end
  
end