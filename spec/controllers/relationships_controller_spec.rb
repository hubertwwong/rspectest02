require 'spec_helper'

describe RelationshipsController do
  
  describe "authorized user" do
    before(:each) do
      # primary user to deal with
      @username = "fake"
      @useremail = "fake@fake.org"
      @user = Factory(:user, :username => @username, :email => @useremail, :password => "password")
      sign_in @user
    end
  
    describe "factory" do
      before(:each) do
        @result = User.find_by_username(@username)
      end
      
      it "must create a user" do
        @result.username.should == @username
      end
    end
  
    describe "create (follow) action" do
      before(:each) do
        # dummy user to add later.
        @user3name = "fake3"
        @user3email = "fake3@fake.org"
        @user3 = Factory(:user, :username => @user3name, :email => @user3email, :password => "password")
        @user3.save   # only needed because the controller is accessing the db.
      end
      
      it "should have 0 relationship before the create controller" do
        @user.relationships.size.should be(0)
      end
      
      describe "POST" do
        before(:each) do
           post :create, :followed_id => @user3.id
        end
        
        it "should assgin @follow_user a valid value" do
          assigns[:user].should == @user3
        end
        
        it "should increase the number of relationships to 1" do
          @user.relationships.size.should be(1)
        end
        
        it "should redirect to the following page" do
          response.should redirect_to(request.referer)
        end
      end
    end
    
    describe "destroy (unfollow) action" do
      before(:each) do
        # dummy users that will be followed by the primary user.
        @user2name = "fake2"
        @user2email = "fake2@fake.org"
        @user2 = Factory(:user, :username => @user2name, :email => @user2email, :password => "password")
        @user2.save   # save to db so i can test finding it.
        
        # create the relationship. use a factory, not any methods to keep this portable..
        @relationship = Factory(:relationship, :follower_id => @user.id, :followed_id => @user2.id)
      end
      
      it "should have 1 relationship before the create controller" do
        @user.relationships.size.should be(1)
      end
      
      describe "DELETE" do
        before(:each) do
           @id_to_destroy = @user.relationships.find_by_followed_id(@user2)
           delete :destroy, :id => @id_to_destroy
        end
        
        it "should assgin @unfollow_user a valid value" do
          assigns[:user].should == @user2
        end
        
        it "should have on relationships after delete" do
          @user.relationships.size.should be(0)
        end
        
        it "should redirect to the following page" do
          response.should redirect_to(request.referer)
        end
      end
    end
  end
  
end
