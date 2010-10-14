require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end
  it { should have_many :authentications }
end