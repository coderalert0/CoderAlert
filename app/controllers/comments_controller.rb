class CommentsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket, find_by: :slug
  load_and_authorize_resource :article, find_by: :slug
  load_and_authorize_resource :comment, through: %i[article ticket]

  def create
    form.submit ? flash.notice = 'The comment was added successfully' : flash.alert = form.display_errors
    redirect_to resource_path
  end

  def destroy
    if @comment.destroy
      flash.notice = 'The comment was deleted successfully'
    else
      flash.alert = 'The comment could not be deleted'
    end

    redirect_to resource_path
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

  def resource_path
    case owner
    when Ticket
      project_ticket_path(@project, @ticket)
    when Article
      project_article_path(@project, @article)
    end
  end
end
