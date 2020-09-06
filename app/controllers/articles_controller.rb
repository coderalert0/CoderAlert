class ArticlesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :article

  def show; end

  def new
    @form = CreateArticleForm.new
  end

  def create
    @form = CreateArticleForm.new form_params.merge(user: current_user, project: @project)
    redirect_to root_path if @form.submit
  end

  private

  def form_params
    params.require(:create_article_form).permit(CreateArticleForm.accessible_attributes)
  end
end
