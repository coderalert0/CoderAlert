class ArticlesController < ApplicationController
  before_action :load_and_authorize_project
  load_and_authorize_resource

  def index
    query = params[:search_articles].try(:[], :query)

    @articles = if query
                  Article.search("*#{query}*").records
                else
                  @project.articles
                end

    @articles = @articles.decorate
  end

  def show
    @comment_form = CreateCommentForm.new
  end

  def new
    @form = CreateArticleForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = 'The article was created successfully'
      redirect_to project_articles_path(@project)
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def edit
    @form = EditArticleForm.new article: @article
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = 'The article was edited successfully'
      redirect_to project_articles_path(@project)
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def destroy
    if @article.destroy
      flash.notice = 'The project was deleted successfully'
      redirect_to project_articles_path(@project)
    else
      flash.alert = 'The project could not be deleted'
      render :show
    end
  end

  private

  def form_params(clazz)
    params.require(clazz.to_s.snakify.to_sym).permit(clazz.accessible_attributes)
  end

  def create_form
    CreateArticleForm.new form_params(CreateArticleForm).merge(user: current_user, project: @project)
  end

  def edit_form
    EditArticleForm.new form_params(EditArticleForm).merge(user: current_user, project: @project, article: @article)
  end

  def load_and_authorize_project
    # need to authorize
    @project = Project.friendly.find(params[:project_id])
  end
end
