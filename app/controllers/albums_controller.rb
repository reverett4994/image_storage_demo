class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  # GET /albums
  # GET /albums.json
  def index
    if params[:user]
      @user=User.friendly.find(params[:user])
      @albums = @user.albums
      gon.albums=""
      if user_signed_in?
        current_user.albums.each do |a|
          gon.albums+=a.name + ","
        end
        gon.albums.chomp!(",")
      end
    else
      if user_signed_in?
        @albums = current_user.albums
        gon.albums=""
        current_user.albums.each do |a|
          gon.albums+=a.name + ","
        end
        gon.albums.chomp!(",")
      else
        redirect_to "/users/sign_in"
      end
    end


  end

  # GET /albums/12
  # GET /albums/1.json
  def show
    redirect_to images_path(sort:@album.id)
  end

  # GET /albums/new
  def new
    @album = current_user.albums.build
  end

  # GET /albums/1/edit
  def edit
    if user_signed_in? == false || current_user != @album.user
      redirect_to '/'
    end
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = current_user.albums.build(album_params)
    respond_to do |format|
      if @album.save
        format.html { redirect_to "/albums/#{@album.name}/add-images", notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    if @album.user=current_user
      @album.destroy
      respond_to do |format|
        format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def change_images
    @album = Album.find(params[:name])
    @images= @album.images.paginate(:page => params[:page], :per_page => 3)
    gon.album=@album.id
  end

  def add_images
    @album = Album.find(params[:name])
    @images=current_user.images.paginate(:page => params[:page], :per_page => 3)
    gon.album=@album.id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.where("name LIKE ?",params[:name]).limit(1).last
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:name)
    end
end
