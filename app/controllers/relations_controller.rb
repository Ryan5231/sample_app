class RelationsController < ApplicationController
  before_filter :signed_in_user
  
  def create
    @user = User.find(params[:relation][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    @user = Relation.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html{ redirect_to @user }
      format.js
    end
  end
end
  