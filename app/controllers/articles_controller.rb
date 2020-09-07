class ArticlesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :article

  def index
    @articles = @project.articles
  end

  def show; end

  def new
    @form = CreateArticleForm.new
  end

  def create
    @form = CreateArticleForm.new form_params.merge(user: current_user, project: @project)
    redirect_to project_articles_path(@project) if @form.submit
  end

  private

  def form_params
    params.require(:create_article_form).permit(CreateArticleForm.accessible_attributes)
  end
end
