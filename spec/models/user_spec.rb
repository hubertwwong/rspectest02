require 'spec_helper'

describe User do

  describe "initialization" do
    it "should create user using factory girl" do
      u = Factory(:user)
      u.should_not be_nil
    end
  end
  
  describe "validations" do
  end
  
  describe "associations" do
    it "should have a tweets method" do
      u = User.new
      u.should respond_to(:tweets)
    end
    
    it "should have a relationships method" do
      u = User.new
      u.should respond_to(:relationships)
    end
    
    it "should have a following method" do
      u = User.new
      u.should respond_to(:following)
    end
    
    it "should have a reverse relationships method" do
      u = User.new
      u.should respond_to(:reverse_relationships)
    end
    
    it "should have a followers method" do
      u = User.new
      u.should respond_to(:followers)
    end
  end
  
  describe "following methods" do
    before(:each) do
      @user_follower = Factory(:user, :email => "demo10@demo.com")
      @user_main = Factory(:user, :email => "demo11@demo.com")
    end
    
    it "follow! should create a relationship" do
      @user_main.relationships.size.should == 0
      @user_main.follow!(@user_follower)
      @user_main.relationships.size.should == 1
      @user_main.relationships.first.followed_id.should == @user_follower.id
    end
    
    it "following? should check if a relationship exist between follower and following" do
      @user_main.following?(@user_follower).should be_false
      @user_main.follow!(@user_follower)
      @user_main.following?(@user_follower).should be_true
    end
    
    it "unfollow! should remove a relationship" do
      @user_main.follow!(@user_follower)
      @user_main.relationships.size.should == 1
      @user_main.unfollow!(@user_follower)
      @user_main.relationships.size.should == 0
    end
  end
  
  describe "search methods" do
    before(:each) do
      @user01= Factory(:user, :email => "demo10@demo.com", :username => "demo10")
      @user02 = Factory(:user, :email => "demo11@demo.com", :username => "demo11")
      @user03 = Factory(:user, :email => "blah11@blah.com", :username => "blah11")
      @user01.save
      @user02.save
      @user03.save
    end
    
    it "should have 3 items in the db" do
      result = User.all.size
      result.should == 3
    end
    
    it "searching the exact term should return 1 item" do
      result = User.search_by_username("demo10")
      result.should_not be_nil
      result.size.should == 1
    end
    
    it "searching the exact term should return 2 item" do
      result = User.search_by_username("demo")
      result.should_not be_nil
      result.size.should == 2
    end
  end
  
end
