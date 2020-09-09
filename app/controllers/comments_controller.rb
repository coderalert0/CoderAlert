class CommentsController < ApplicationController
  load_and_authorize_resource :article
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket
  load_and_authorize_resource :comment, through: %i[article ticket]

  def create
    @form = CreateCommentForm.new form_params.merge(user: current_user, commentable: owner)
    redirect_to create_redirect_path if @form.submit
  end

  def destroy
    redirect_to create_redirect_path if @comment.destroy
  end

  private

  def form_params
    params.require(:create_comment_form).permit(CreateCommentForm.accessible_attributes)
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
