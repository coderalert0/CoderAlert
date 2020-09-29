class CommentsController < ApplicationController
  before_action :load_and_authorize_project
  before_action :load_and_authorize_owner
  load_and_authorize_resource :comment, through: %i[article ticket]

  def create
    if form.submit
      flash.notice = 'The comment was added successfully'
      redirect_to create_redirect_path
    else
      flash.alert = form.display_errors
      redirect_to article_path(@article)
    end
  end

  def destroy
    if @comment.destroy
      flash.notice = 'The comment was deleted successfully'
    else
      flash.alert = 'The comment could not be deleted'
    end

    redirect_to create_redirect_path
  end

  private

  def form_params
    params.require(:create_comment_form).permit(CreateCommentForm.accessible_attributes)
  end

  def form
    CreateCommentForm.new form_params.merge(user: current_user, commentable: owner)
  end

  def owner
    @ticket || @article
  end

  def create_redirect_path
    case owner
    when Ticket
      ticket_path(@ticket)
    when Article
      article_path(@article)
    end
  end

  def load_and_authorize_project
    # need to authorize
    @project = Project.friendly.find(session[:project_id])
  end

  def load_and_authorize_owner
    # need to authorize

    if params[:article_id]
      @article = @project.articles.friendly.find(params[:article_id])
    elsif params[:ticket_id]
      @ticket = @project.tickets.friendly.find(params[:ticket_id])
    end
  end
end
