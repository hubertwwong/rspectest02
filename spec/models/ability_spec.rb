require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  
  describe "guest" do
    before(:each) do
      @user = User.new
      @ability = Ability.new(@user)
    end
    
    it "should be able to read tweets" do
      @ability.should be_able_to(:read, Tweet)
    end
    
    it "should not be able to manage tweets" do
      @ability.should_not be_able_to(:manage, Tweet)
    end
    
    it "should not be able to manage user" do
      @ability.should_not be_able_to(:manage, User)
    end
    
    it "should not be able to manage relationships" do
      @ability.should_not be_able_to(:manage, Relationship)
    end
    
    it "should be able to read users" do
      @ability.should be_able_to(:read, User)
    end
  end
  
  describe "user" do
    before(:each) do
      @user = Factory(:user)
      @ability = Ability.new(@user)
      
      @user2 = Factory(:user, :email => "demo02@demo.com")
      
      @tweet_by_user = Factory(:tweet, :content => "herp derp", :user => @user)
      @tweet_by_other_user = Factory(:tweet, :user => @user2)
    end
    
    it "should be able to manage tweets that you own" do
      @ability.should be_able_to(:manage, @tweet_by_user)
    end
    
    it "should not be able to manage tweets that you dont own" do
      @ability.should_not be_able_to(:manage, @tweet_by_other_user)
    end
    
    it "should be able to manage own user resources" do
      @ability.should be_able_to(:manage, @user)
    end
    
    it "should be able to read users" do
      @ability.should be_able_to(:read, User)
    end
    
    it "should be able to manage relationship that you own."
  end
  
end