class CommentsController < ApplicationController
  load_and_authorize_resource :article
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket
  load_and_authorize_resource :comment, through: %i[article ticket]

  def create
    if form.submit
      flash.notice = 'The comment was added successfully'
      redirect_to create_redirect_path
    else
      flash.alert = form.display_errors
      redirect_to project_article_path(@project, @article)
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
      project_ticket_path(@project, @ticket)
    when Article
      project_article_path(@project, @article)
    end
  end
end
