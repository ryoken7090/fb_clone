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
      if @story.save
        redirect_to stories_path, notice: "投稿しました！"
      else
        render :new
      end
    end
  end

  def update
    if @story.update(story_params)
      redirect_to stories_path, notice: "変更しました！"
    else
      render :edit
    end
  end

  def destroy
    if @story.user != current_user
      redirect_to stories_path
    end
    @story.destroy
    redirect_to stories_path, notice:"削除しました！"
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
