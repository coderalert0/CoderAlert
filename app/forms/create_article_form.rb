class CreateArticleForm < BaseForm
  attr_accessor :title, :content, :user, :project, :attachments
  attr_writer :article

  nested_attributes :title, :content, :user, :project, :attachments, to: :article

  accessible_attr :title, :content, attachments: []

  def article
    @article ||= Article.new
  end

  def _submit
    article.save!
  end
end
