require 'spec_helper'

describe Tweet do
  
  describe "validations" do    
    # check the enforcement of the presense validation.
    [:content].each do |attr|
      it "must have a " + attr.to_s do
        t = Tweet.new
        t.should_not be_valid
        t.errors_on(:attr).should_not be_nil
      end
    end
  end
  
  describe "associations" do
    it "should have a user method" do
      t = Tweet.new
      t.should respond_to(:user)
    end
  end
  
  describe "feed" do
    before(:each) do
      @user01= Factory(:user, :email => "demo10@demo.com", :username => "demo10")
      @user02 = Factory(:user, :email => "demo11@demo.com", :username => "demo11")
      @user03 = Factory(:user, :email => "demo12@blah.com", :username => "demo12")
      @tweet01 = Factory(:tweet, :content => "tweet01")
      @tweet02 = Factory(:tweet, :content => "tweet02")
      @tweet03 = Factory(:tweet, :content => "tweet03")
      @tweet04 = Factory(:tweet, :content => "tweet04")
      @tweet05 = Factory(:tweet, :content => "tweet05")
      @tweet06 = Factory(:tweet, :content => "tweet06")
      
      # assigns 2 tweets per person
      @user01.tweets = [@tweet01, @tweet02]
      @user02.tweets = [@tweet03, @tweet04]
      @user03.tweets = [@tweet05, @tweet06]
      
      # user 1 follows user 2.
      @user01.follow!(@user02)
      
    end
    
    describe "factory" do
      it "should have 3 users" do
        User.all.size.should be(3)
      end
      
      it "should create a user with 2 tweets" do
        @user01.tweets.size.should be(2)
      end
      
      it "should assign user1 to follow user2" do
        @user01.following?(@user02).should_not == nil
      end
    end
    
    describe "methods" do
      describe "user_ids_for_feed" do
        before(:each) do
          # user feed.
          @user_ids = Tweet.user_ids_for_feed(@user01)
        end
        
        it "should contain 2 items." do
          @user_ids.size.should be(2)
        end
        
        it "should contain original user and user02" do
          @user_ids[0].should be(@user02.id)
          @user_ids[1].should be(@user01.id)
        end
      end
      
      describe "feed" do
        before(:each) do
          # user feed.
          @feed = Tweet.feed(@user01)
        end
        
        it "should not return nil" do
          @feed.should_not be(nil)  
        end
        
        it "should return 4 items" do
          @feed.size.should be(4)
        end
        
        it "should return the correct items" do
          @feed.find(@tweet01).should_not be_nil
          @feed.find(@tweet02).should_not be_nil
          @feed.find(@tweet03).should_not be_nil
          @feed.find(@tweet04).should_not be_nil
        end
      end
    end
  end
  
end
