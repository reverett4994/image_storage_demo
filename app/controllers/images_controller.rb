class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /images
  # GET /images.json
  def index
# SORTING FOR ALBUMS
    if params[:sort]
      @album=Album.find(params[:sort])
      @images=@album.images.paginate(:page => params[:page], :per_page => 3)
    elsif params[:user]
      @u=User.friendly.find(params[:user])
      if user_signed_in? && @u.friends_with?(current_user)
        gon.friends= true
      end
      if user_signed_in? && @u.friends_with?(current_user) || @u==current_user
        @images=@u.images.where("only_friends OR public LIKE true").paginate(:page => params[:page], :per_page => 3)
        if params[:r_friends]
          @images=@u.images.where("only_friends LIKE true").paginate(:page => params[:page], :per_page => 3)
        elsif params[:r_public]
          @images=@u.images.where("public LIKE true").paginate(:page => params[:page], :per_page => 3)
        end
      else
        @images=@u.images.where("public LIKE true").paginate(:page => params[:page], :per_page => 3)
        gon.friends= false
      end
# SORTING FOR FRIENDS
    elsif params[:friends]
      @friends=current_user.friends.all
      @friends_images=[]

      if params[:r_friends]
        @friends.each do |friend|
          friend.images.each do |image|
            if image.private == false && image.public == false
              @friends_images<<image
            end
          end
        end
      elsif params[:r_public]
        @friends.each do |friend|
          friend.images.each do |image|
            if image.public == true
              @friends_images<<image
            end
          end
        end
      else
        @friends.each do |friend|
          friend.images.each do |image|
            if image.private == false
              @friends_images<<image
            end
          end
        end
      end
      @images=@friends_images.paginate(:page => params[:page], :per_page => 3)
#SORTING FOR NEWIST PUBLIC
    elsif params[:public]
      @public=true
      @images = Image.where("public LIKE true").paginate(:page => params[:page], :per_page => 3)
# SORTING FOR YOUR OWN
    else
      @images = current_user.images.paginate(:page => params[:page], :per_page => 3)
      gon.friends= "self"
      if params[:r_friends]
        @images=current_user.images.where("only_friends LIKE true").paginate(:page => params[:page], :per_page => 3)
      elsif params[:r_public]
        @images=current_user.images.where("public LIKE true").paginate(:page => params[:page], :per_page => 3)
      elsif params[:r_private]
        @images=current_user.images.where("private LIKE true").paginate(:page => params[:page], :per_page => 3)
      end
    end
#JAVASCRIPT VARIBLES
    if @u
      gon.user = @u.username
    elsif user_signed_in?
      gon.user=current_user.username
    end

    if params[:r_public]
      gon.radio="public"
    elsif params[:r_friends]
      gon.radio="friends"
    elsif params[:r_private]
      gon.radio="private"
    end

  end


  # GET /images/1
  # GET /images/1.json
  def show
    gon.image=@image.id
    if user_signed_in?
      @albums=current_user.albums
    end
  end

  # GET /images/new
  def new
    @image = current_user.images.build
  end

  # GET /images/1/edit
  def edit
  end

  def add_to_album
    @image=Image.find(params[:image])
    @album=Album.find(params[:album])
    @image.albums << @album unless @image.albums.include?(@album)
    @album.images << @image unless @album.images.include?(@image)
    respond_to do |format|
      if @image.save && @album.save
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      end
    end
  end

  def remove_album
    @image=Image.find(params[:image])
    @album=Album.find(params[:album])
    @image.albums.delete(@album) unless @image.albums.include?(@album) == false
    @album.images.delete(@image) unless @album.images.include?(@image) == false
    respond_to do |format|
      if @image.save && @album.save
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_url, notice: 'error try again' }
        format.json { head :no_content }
      end
    end
  end

  # POST /images
  # POST /images.json
  def create
    if current_user.temp_pic.exists?
      @image = current_user.images.build(image_params.merge(file:current_user.temp_pic))

      respond_to do |format|
        if @image.save
          current_user.temp_pic=nil
          current_user.save
          format.html { redirect_to @image, notice: 'Image was successfully created.' }
          format.json { render :show, status: :created, location: @image }
        else
          format.html { render :new }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      end

    else
      redirect_to "/"
    end

  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def temp_pic
  @user=current_user
  @user.temp_pic=params[:file]
  @user.save
  respond_to do |format|
      format.html {  }
      format.json { render json:" @image.errors, status: :unprocessable_entity "}
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:name,:file,:public,:only_friends,:private)
    end
end
