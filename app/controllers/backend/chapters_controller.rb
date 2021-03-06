class Backend::ChaptersController < Backend::BackendController

  before_action :find_chapter, only: [:edit, :destroy, :update, :show]
  before_action :find_course, only: [:index, :new]

  def index
    @chapters = Chapter.where course_id: params[:course_id]
    render 'index'
  end

  def create
    @chapter = Chapter.new chapter_params
    if @chapter.save
      flash[:success] = t('chapters.flash_messages.chapter_created')
      redirect_to :backend_course_chapters
    else
      flash[:error] = @chapter.errors.messages.map{|k,v| v}.flatten.join " -- "
      redirect_to new_backend_course_chapter_path
    end
  end

  def new
    @chapter = Chapter.new
    render 'new'
  end

  def edit
    render 'edit'
  end

  def destroy
    if @chapter.destroy
      flash[:success] = t('chapters.flash_messages.chapter_destroyed')
      redirect_to backend_course_chapters_path(@chapter.course)
    else
      @errors = @chapter.errors
      render 'shared/errors'
    end
  end

  def update
    @chapter.remove_picture! if params["chapter"]["remove_picture"] == "1"
    if @chapter.update_attributes(chapter_params)
      flash[:success] = t('chapters.flash_messages.chapter_updated')
      redirect_to backend_course_chapters_path(@chapter.course)
    else
      flash[:error] = @chapter.errors.messages.map{|k,v| v}.flatten.join " -- "
      redirect_to edit_backend_chapter_path(@chapter)
    end
  end

  def show
    render 'show'
  end

  private
  def chapter_params
    params.require(:chapter).permit(:id, :title, :description, :picture, :course_id)
  end

  def find_chapter
    @chapter = Chapter.find params[:id]
  end

  def find_course
    @course = Course.find params[:course_id]
  end
end
