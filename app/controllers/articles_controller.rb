class ArticlesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project, find_by: :slug

  def index
    query = params[:search_articles].try(:[], :query)

    @articles = if query
                  Article.search("*#{query}*").records
                else
                  @project.articles
                end

    @articles = @articles.page(params[:page]).decorate
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
      flash.notice = 'The article was deleted successfully'
      redirect_to project_articles_path(@project)
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
end
