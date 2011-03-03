require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before do
    @user = Factory(:user, :first_name => nil, :last_name => nil)
    @user.login = nil
    @user.email = nil
    @facebook_omniauth = {"user_info"=>{"name"=>"George Strait", "urls"=>{"Facebook"=>"http://www.facebook.com/profile.php?id=1", "Website"=>nil}, "nickname"=>"profile.php?id=1", "last_name"=>"Strait", "image"=>"http://graph.facebook.com/1/picture?type=square", "first_name"=>"George", "email"=>"george@example.com"}, "uid"=>"75757575", "credentials"=>{"token"=>"bogustoken"}, "extra"=>{"user_hash"=>{"name"=>"George Strait", "timezone"=>-8, "id"=>"88888", "last_name"=>"Strait", "updated_time"=>"2007-10-31T19:43:13+0000", "locale"=>"en_US", "link"=>"http://www.facebook.com/profile.php?id=757575", "email"=>"george@example.com", "first_name"=>"George"}}, "provider"=>"facebook"}  
    @willies_twitter = "http://twitter.com/willienelson"
    @willies_site = "http://www.willienelson.com"
    @twitter_omniauth = {"user_info"=>{"name"=>"Willie Nelson", "location"=>"Nashville", "urls"=>{"Website"=>@willies_site, "Twitter"=>@willies_twitter}, "nickname"=>"willienelson", "description"=>"Singing.", "image"=>"http://a3.twimg.com/profile_images/1073715704/GettyImages_79495526-1-0_bigger.jpg"}, "uid"=>"757575", "credentials"=>{"token"=>"bogus", "secret"=>"secret"}, "extra"=>{"user_hash"=>{"name"=>"Willie Nelson", "profile_sidebar_border_color"=>"181A1E", "profile_background_tile"=>false, "profile_sidebar_fill_color"=>"252429", "created_at"=>"Tue Jul 03 03:05:32 +0000 2007", "location"=>"The bus", "profile_image_url"=>"http://a3.twimg.com/profile_images/1073715704/GettyImages_79495526-1-0_bigger.jpg", "follow_request_sent"=>false, "profile_link_color"=>"2FC2EF", "is_translator"=>false, "id_str"=>"757575", "favourites_count"=>0, "contributors_enabled"=>false, "url"=>"http://www.willienelson.com", "utc_offset"=>-25200, "id"=>757575, "profile_use_background_image"=>true, "listed_count"=>23, "followers_count"=>318, "protected"=>false, "lang"=>"en", "profile_text_color"=>"666666", "profile_background_color"=>"1A1B1F", "notifications"=>false, "verified"=>false, "geo_enabled"=>false, "time_zone"=>"Mountain Time (US & Canada)", "description"=>"Singing", "friends_count"=>429, "statuses_count"=>1185, "status"=>{"coordinates"=>nil, "favorited"=>false, "truncated"=>false, "created_at"=>"Wed Mar 02 04:12:22 +0000 2011", "id_str"=>"8787878", "in_reply_to_user_id_str"=>"7685", "text"=>"howdy", "contributors"=>nil, "in_reply_to_status_id_str"=>"87878", "id"=>87878, "retweet_count"=>0, "geo"=>nil, "retweeted"=>false, "in_reply_to_user_id"=>87878, "in_reply_to_screen_name"=>"george", "place"=>nil, "source"=>"<a href=\"http://www.tweetdeck.com\" rel=\"nofollow\">TweetDeck</a>", "in_reply_to_status_id"=>7676767}, "profile_background_image_url"=>"http://a3.twimg.com/profile_images/1073715704/GettyImages_79495526-1-0_bigger.jpg", "following"=>false, "show_all_inline_media"=>false, "screen_name"=>"willienelson"}, "provider"=>"twitter"}}
    @google_omniauth = {"user_info"=>{"name"=>"Hank Williams", "uid"=>"hank@gmail.com", "email"=>"hank@gmail.com"}, "uid"=>"hank@gmail.com", "credentials"=>{"token"=>"bogus", "secret"=>"secret"}, "extra"=>{"user_hash"=>{"encoding"=>"UTF-8", "version"=>"1.0", "feed"=>{"xmlns$batch"=>"http://schemas.google.com/gdata/batch", "category"=>[{"term"=>"http://schemas.google.com/contact/2008#contact", "scheme"=>"http://schemas.google.com/g/2005#kind"}], "author"=>[{"name"=>{"$t"=>"Hank Williams"}, "email"=>{"$t"=>"hank@gmail.com"}}], "title"=>{"$t"=>"Hank Williams's Contacts", "type"=>"text"}, "xmlns$gContact"=>"http://schemas.google.com/contact/2008", "openSearch$startIndex"=>{"$t"=>"1"}, "id"=>{"$t"=>"hank@gmail.com"}, "xmlns$gd"=>"http://schemas.google.com/g/2005", "openSearch$totalResults"=>{"$t"=>"1251"}, "xmlns$openSearch"=>"http://a9.com/-/spec/opensearchrss/1.0/", "provider"=>"google"}}}}
  end
  it { should have_many :authentications }
  
  describe "apply_omniauth" do
    describe "facebook" do
      before(:each) do
        @user.apply_omniauth(@facebook_omniauth)
      end
      it "should set first name as the login" do
        @user.login.should == "George"
      end
      it "should set email" do
        @user.email.should == "george@example.com"
      end
      it "should set the first name" do
        @user.first_name.should == "George"
      end
      it "should set the last name" do
        @user.last_name.should == "Strait"
      end
      it "should build an authentication" do
        @user.authentications.length.should == 1
      end
    end
    describe "twitter" do
      before(:each) do
        @user.apply_omniauth(@twitter_omniauth)
      end
      it "should set first name as the login" do
        @user.login.should == "willienelson"
      end
      it "should set the first name" do
        @user.first_name.should == "Willie"
      end
      it "should set the last name" do
        @user.last_name.should == "Nelson"
      end
    end
  end
  
  describe "profile_from_omniauth" do
    before(:each) do
      @user.profile_from_omniauth(@twitter_omniauth)
    end
    it "should set the user's profile location" do
      @user.profile.location.should == "Nashville"
    end
    it "should set the user's profile about field" do
      @user.profile.about.should == "Singing."
    end
    it "should download the user's profile photo" do
    end    
  end
  
  describe "feeds_from_omniauth" do
    describe "facebook" do
      before(:each) do
        @user = Factory(:user)
        @user.feeds_from_omniauth(@facebook_omniauth)
      end
      it "should only add one feed" do
        @user.own_feeds.length.should == 1
      end
      it "should add a website for facebook" do
        @user.own_feeds[0].uri.should be_blank
        @user.own_feeds[0].display_uri.should == "http://www.facebook.com/profile.php?id=1"
      end
    end
    describe "twitter" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should add both feed and site for user" do
        @feed = Factory(:feed, :display_uri => @willies_twitter)
        @site = Factory(:feed, :display_uri => @willies_site)        
        Feed.should_receive(:make_feeds_or_website).with(@willies_twitter, @user, 'Twitter').and_return([@feed])
        Feed.should_receive(:make_feeds_or_website).with(@willies_site, @user, 'Website').and_return([@site])
        @user.feeds_from_omniauth(@twitter_omniauth)
        @user.own_feeds.find_by_display_uri(@willies_twitter).should_not be_blank
        @user.own_feeds.find_by_display_uri(@willies_site).should_not be_blank
      end
    end
    describe "google" do
      before(:each) do
        @user.feeds_from_omniauth(@google_omniauth)
      end
      it "shouldn't add any feeds" do
        @user.own_feeds.length.should == 0
      end
    end
  end
  
end
