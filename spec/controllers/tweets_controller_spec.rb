require 'spec_helper'

describe TweetsController do
  
  # only check authorized user actions to make sure stuff works.
  # unauthorized stuff will be handled by cancan.
  # in the ability class. testing will be in ability_spec
  describe "authorized user" do
    before(:each) do
      @user = Factory(:user)
      sign_in @user
      
      @tweet_factory_item = Factory(:tweet, :user => @user)
    end
    
    describe "GET" do
      describe "index" do
        before(:each) do
          get :index
        end
          
        it "should be successful" do
          response.should be_successful
        end
        
        it "should render the template" do
          response.should render_template('index')
        end
        
        it "should assign @tweets to an array of all tweets" do
          assigns[:tweets] == [@tweet] 
        end
      end
      
      describe "new" do
        before(:each) do
          get :new
        end
        
        it "should be successful" do
          response.should be_successful
        end
        
        it "should render the template" do
          response.should render_template('new')
        end
        
        it "should assign a new @tweet object" do
          assigns[:tweet].should_not be_nil
          assigns[:tweet].should be_kind_of(Tweet)
          assigns[:tweet].should be_new_record 
        end
      end
      
      describe "show" do
        before(:each) do
          get :show, :id => @tweet_factory_item.id
        end
        
        it "should be successful" do
          response.should be_successful
        end
        
        it "should render the template" do
          response.should render_template('show')
        end
        
        it "should assign @tweet to the specified object" do
          assigns[:tweet].should_not be_nil
          assigns[:tweet].content.should_not be_blank
        end
      end
      
      describe "edit" do
        before(:each) do
          get :edit, :id => @tweet_factory_item.id
        end
        
        it "should be successful" do
          response.should be_successful
        end
        
        it "should render the template" do
          response.should render_template('edit')
        end
        
        it "should assign @tweet to the specified object" do
          assigns[:tweet].should_not be_nil
          assigns[:tweet].content.should_not be_blank
        end
      end
      
      describe "feed" do
        before(:each) do
          get :feed
        end
        
        it "should be successful" do
          response.should be_successful
        end
        
        it "should render the template" do
          response.should render_template('feed')
        end
        
        it "should assign @tweets to an array of all tweets" do
          assigns[:tweets] == [@tweet] 
        end
      end
    end  
    
    describe "POST create" do
      describe "success" do
        before(:each) do
          @attr = {:content => "test str", :user_id => @user.id}
          post :create, :tweet => @attr
        end
        
        it "should assign the instance variable" do
          assigns[:tweet].content.should == "test str"
        end
        
        it "should have a flash message" do
          flash[:notice].should_not be_blank
        end
        
        it "should redirect to a index page" do
          response.should redirect_to(tweets_path)
        end
      end
      
      describe "failure" do
        before(:each) do
          post :create
        end
        
        it "should assign the instance variable" do
          assigns[:tweet].content.should be_blank
        end
        
        it "should re-render the form page" do
          response.should render_template("index")
        end
      end
    end
    
    describe "PUT update" do
      before(:each) do
        @tweet1_old_msg = "tweet uno"
        @tweet2_old_msg = "tweet dos"
        @tweet1 = Factory(:tweet, :content => @tweet1_old_msg, :user => @user)
        @tweet2 = Factory(:tweet, :content => @tweet2_old_msg, :user => @user)
        @tweet1_id = @tweet1.id
        @tweet1_new_msg = "updated tweet"
        @attr_success = {:content => @tweet1_new_msg}
        @attr_failure = {:content => ""}
      end
      
      describe "success" do
        before(:each) do
          # need to figure out to load the params hash.
          # not really sure...
          put :update, :id => @tweet1_id, :tweet => @attr_success
        end
        
        it "should assigns the instance variable" do
          assigns[:tweet].should_not be_blank
          assigns[:tweet].content.should == @tweet1_new_msg
        end
        
        it "should have a flash message" do
          flash[:notice].should_not be_blank
        end
        
        it "should redirect to a index page" do
          response.should redirect_to(tweets_path)
        end
      end
      
      describe "failure" do
        before(:each) do
          put :update, :id => @tweet1_id, :tweet => @attr_failure  
        end
        
        it "should re-render the form page" do
          response.should render_template('edit')
        end
      end
    end
    
    describe "DELETE" do
      before(:each) do
        @tweet1_old_msg = "tweet uno"
        @tweet1 = Factory(:tweet, :content => @tweet1_old_msg, :user => @user)
        @tweet1_id = @tweet1.id
        @tweet_count_old = Tweet.count
            
        delete :destroy, :id => @tweet1_id
      end
      
      it "should assign the instance variable" do
        assigns[:tweet].should_not be_nil
      end
      
      it "should be 1 less item in the db after the deletion" do
        @tweet_count_diff = @tweet_count_old - Tweet.count
        @tweet_count_diff.should == 1
      end
      
      it "should redirect to the index page" do
        response.should redirect_to(tweets_path)
      end    
    end
  end
  
end
