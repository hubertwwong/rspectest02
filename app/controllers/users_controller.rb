class UsersController < ApplicationController

  #before_filter :authenticate_user!
  load_and_authorize_resource
  
  
  
  def show
    @user = User.find_by_id(params[:id])
    @tweets = @user.tweets.order("created_at DESC").page(params[:page]).per(10)
    @relationship = current_user.relationships.find_by_followed_id(@user.id) # need to test.
  end
  
  # search for users...
  def search
    @users = User.search_by_username(params[:username]).order("username").page(params[:page]).per(10)
  end
  
end
