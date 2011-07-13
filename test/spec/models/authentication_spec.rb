require File.dirname(__FILE__) + '/../spec_helper'

describe Authentication do
  before do
    @authentication = Factory(:authentication, :provider => 'twitter')
    @user = @authentication.authenticatable
  end
  
  it { should belong_to :authenticatable }
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
  
  describe "access_token" do
    it "should get the access_token for twitter" do
      @authentication.access_token.should_not be_blank
    end    
  end
  
  describe "consumer" do
    it "should get the consumer for twitter" do
      @authentication.consumer.should_not be_blank
    end
  end
  
  describe "strategy" do
    it "should get the omniauth twitter strategy" do
      @authentication.strategy.is_a?(OmniAuth::Strategies::Twitter).should be_true
    end
  end
  
  describe "all_services" do
    it "should find all configured services" do
      Authentication.all_services.length.should == Secrets.auth_credentials.keys.length
      Authentication.all_services.should include('twitter')
    end    
  end
  
  describe "unused_services" do
    it "should find services the user is not using" do
      unused = Authentication.unused_services(@user.authentications)
      unused.any?{ |a| a == 'twitter' }.should_not be_true
      unused.any?{ |a| a == 'facebook' }.should be_true
      unused.any?{ |a| a == 'linked_in' }.should be_true
      unused.length.should == Secrets.auth_credentials.keys.length-1
    end
  end
  
end