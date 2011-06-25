class RelationshipsController < ApplicationController
  
  load_and_authorize_resource
  
  
  
  # show what users you are followings...
  def following
    @following = current_user.following.order("username").page(params[:page]).per(10)
  end
  
  # show users who are following you...
  def followers
    @followers = current_user.followers.order("username").page(params[:page]).per(10)
  end
  
  def create
    @user = User.find(params[:followed_id])
    current_user.follow!(@user)
    redirect_to request.referer
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to request.referer
  end
  
end
