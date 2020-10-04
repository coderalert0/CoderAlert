class ArticlesController < ApplicationController
  before_action :load_project
  before_action :load_article, only: %i[show edit update destroy]
  before_action :initialize_and_authorize_article, only: %i[new create]

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
    authorize! :read, @article

    @comment_form = CreateCommentForm.new
  end

  def new
    @form = CreateArticleForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = 'The article was created successfully'
      redirect_to articles_path
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def edit
    authorize! :update, @article

    @form = EditArticleForm.new article: @article
  end

  def update
    authorize! :update, @article

    @form = edit_form

    if @form.submit
      flash.notice = 'The article was edited successfully'
      redirect_to articles_path
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @article

    if @article.destroy
      flash.notice = 'The article was deleted successfully'
      redirect_to articles_path
    else
      flash.alert = 'The article could not be deleted'
      render :show
    end
  end

  private

  def create_form
    CreateArticleForm.new form_params(CreateArticleForm).merge(article: @article)
  end

  def edit_form
    EditArticleForm.new form_params(EditArticleForm).merge(article: @article)
  end

  def load_project
    # need to authorize
    @project = Project.friendly.find(session[:project_id])
  end

  def load_article
    @article = Project.friendly.find(session[:project_id]).articles.friendly.find(params[:id])
  end

  def initialize_and_authorize_article
    @article = Article.new(user: current_user, project: @project)
    authorize! :create, @article
  end
end
