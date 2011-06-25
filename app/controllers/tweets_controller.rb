class TweetsController < ApplicationController

  #before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    #@tweets = current_user.tweets.all
    @tweet = Tweet.new
    @tweets = current_user.tweets.order("created_at DESC").page(params[:page]).per(10)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tweets }
      #  curl --request GET -H "accept: application/json" http://localhost:3000/tweets
    end
  end

  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @tweet = Tweet.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = Tweet.new(params[:tweet])
    @tweet.user_id = current_user.id
    @tweets = current_user.tweets.order("created_at DESC").page(params[:page]).per(10)
    # tag the tweet to the user.

    respond_to do |format|
      if @tweet.save
        #format.html { redirect_to(@tweet, :notice => 'Tweet was successfully created.') }
        format.html { redirect_to(tweets_path, :notice => 'Tweet was successfully created.') }
      else
        format.html { render :action => "index" }
      end
    end
  end

  def update
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      if @tweet.update_attributes(params[:tweet])
        #format.html { redirect_to(@tweet, :notice => 'tweet was successfully updated.') }
        format.html { redirect_to(tweets_path, :notice => 'Tweet was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy

    respond_to do |format|
      format.html { redirect_to(tweets_url) }
    end
  end
  
  def feed
    @tweets = Tweet.feed(current_user).order("created_at DESC").page(params[:page]).per(10)
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end
