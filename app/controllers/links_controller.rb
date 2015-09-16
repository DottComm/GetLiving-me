class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]

  # VOTABLE
  def upvote
    @link = Link.find(params[:id])
    @link.upvote_by current_user
    redirect_to :back
  end

  def unvote
    @link = Link.find(params[:id])
    @link.unvote_by current_user

    if @link.get_likes.size < 1
      @link.destroy
    end

    redirect_to :back
  end

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = current_user.links.build
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    current_group = session[:current_group_id]
    @link = current_user.links.build(link_params)
    @link.group_id = current_group

    #hack: devise should take care of this, no?
    @link.user_id = current_user.id

    respond_to do |format|
      if @link.save
        # Auto-upvote your own links
        @link.liked_by current_user
        #redirect after
        format.html { redirect_to group_path(current_group), notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url)
    end

    # MC
    def authorized_user
      @link = current_user.links.find_by(id: params[:id])
      redirect_to links_path, notice: "Not authorized to edit this link" if @link.nil?
    end
end
