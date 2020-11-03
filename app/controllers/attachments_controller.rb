class AttachmentsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket, find_by: :slug
  load_and_authorize_resource :article, find_by: :slug
  load_and_authorize_resource :attachment, through: %i[article ticket], class: ActiveStorage::Attachment

  def destroy
    @attachment.purge

    if !ActiveStorage::Attachment.exists?(@attachment.id)
      flash.notice = t(:destroy, scope: %i[attachment flash])
      redirect_to resource_path
    else
      flash.alert = t(:destroy_error, scope: %i[attachment flash])
    end
  end

  private

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
