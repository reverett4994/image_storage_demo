class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    gon.user=@user.id
    @public_count=@user.images.where("public LIKE true").count
    @pfriends_count=@user.images.where("only_friends LIKE true").count
    @private_count=@user.images.where("private LIKE true").count

  end

  def request_friend
    @friend= User.find(params[:friend])
    current_user.friend_request(@friend)

    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      end
    end
  end

  def accept_friend
    @friend= User.where("email LIKE ?",params[:friend])
    @friend=@friend.last
    current_user.accept_request(@friend)

    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      end
    end
  end

end
