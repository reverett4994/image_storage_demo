class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:change_email,:request_friend,:accept_friend,:remove_friend]

  def search
    @user=User.where("username LIKE ?",params[:search])
    if @user.length == 1
      @user=@user.first
      gon.user=@user.id
      @public_count=@user.images.where("public LIKE true").count.to_i
      @friends_count=@user.images.where("only_friends LIKE true").count.to_i
      @private_count=@user.images.where("private LIKE true").count.to_i
      @public_images=@user.images.where("public LIKE true")
    else
      @user=nil
    end
  end
  def show_friends
    @user=current_user
    @friends=@user.friends
  end

  def change_email
    @user=current_user
    if @user.valid_password?(params[:password])
      @user.email=params[:new_email]
      @user.save
      redirect_to "/"
    else
      redirect_to "/pages/set-email"
      flash[:alert] = "Wrong Password"
    end
  end

  def show
    @user = User.friendly.find(params[:id])
    gon.user=@user.id
    @public_count=@user.images.where("public LIKE true").count.to_i
    @friends_count=@user.images.where("only_friends LIKE true").count.to_i
    @private_count=@user.images.where("private LIKE true").count.to_i
    @public_images=@user.images.where("public LIKE true")
  end

  def request_friend
    @friend= User.find(params[:friend])
    if current_user.pending_friends.include?(@friend) || current_user.friends.include?(@friend)
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { render :json => { :id => "Already Pending", :email => "Already Pending",:status_code => "500" } }
       end
     elsif current_user.requested_friends.include?(@friend)
       respond_to do |format|
         format.html { redirect_to root_url, notice: 'error try again' }
         format.json { render :json => { :id => "Already Pending", :email => "Already Pending",:status_code => "400" } }
        end
    else
      current_user.friend_request(@friend)
      current_user.save
      respond_to do |format|
        if user_signed_in?
          format.html { redirect_to root_url, notice: 'error try again' }
          format.json { render :json => { :id => "#{@friend.id}", :email => "#{@friend.email}",:status_code => "200" } }
        else
          format.html { redirect_to root_url, notice: 'error try again' }
          format.json { render json: "sdfsdf" }
        end
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
        format.json { render :json => { :id => "#{@friend.id}", :email => "#{@friend.email}",:status_code => "200" } }
      else
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      end
    end
  end

  def remove_friend
    @friend= User.where("email LIKE ?",params[:friend])
    @friend=@friend.last
    current_user.remove_friend(@friend)
    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { render :json => { :id => "#{@friend.id}", :email => "#{@friend.email}",:status_code => "200" } }
      else
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      end
    end
  end
end
