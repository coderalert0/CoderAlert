class ArticlesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource

  def index
    @articles = @project.articles
  end

  def show
    @comment_form = CreateCommentForm.new
  end

  def new
    @form = CreateArticleForm.new
  end

  def create
    @form = CreateArticleForm.new form_params.merge(user: current_user, project: @project)

    if @form.submit
      flash.notice = 'The article was created successfully'
      redirect_to project_articles_path(@project)
    end
  end

  def destroy
    if @article.destroy
      flash.notice = 'The project was deleted successfully'
      redirect_to project_articles_path(@project)
    end
  end

  private

  def form_params
    params.require(:create_article_form).permit(CreateArticleForm.accessible_attributes)
  end
end
