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
    redirect_to project_articles_path(@project) if @form.submit
  end

  def destroy
    redirect_to project_articles_path(@project) if @article.destroy
  end

  private

  def form_params
    params.require(:create_article_form).permit(CreateArticleForm.accessible_attributes)
  end
end
