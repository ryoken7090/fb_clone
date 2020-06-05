class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  before_action :user_logged_in?, only: %i(index show new edit destroy)

  def index
    @stories = Story.all
  end

  def show
    @favorite = current_user.favorites.find_by(story_id: @story.id)
  end

  def new
    @story = Story.new
  end

  def confirm
    @story = current_user.stories.build(story_params)
    render :new if @story.invalid?
  end

  def edit
    if @story.user != current_user
      redirect_to stories_path
    end
  end

  def create
    @story = current_user.stories.build(story_params)
    if params[:back]
      render :new
    else
      respond_to do |format|
        if @story.save
          format.html { redirect_to @story, notice: 'Story was successfully created.' }
          format.json { render :show, status: :created, location: @story }
        else
          format.html { render :new }
          format.json { render json: @story.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @story.user != current_user
      redirect_to stories_path
    end
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_story
      @story = Story.find(params[:id])
    end

    def story_params
      params.require(:story).permit(:content, :image, :image_cache)
    end

    def user_logged_in?
      unless current_user
        redirect_to new_session_path
      end
    end
end
