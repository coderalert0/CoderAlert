class CreateArticleForm < BaseForm
  attr_writer :article

  nested_attributes :title, :content, :attachments, to: :article

  accessible_attr :title, :content, attachments: []

  def article
    @article ||= Article.new
  end

  def _submit
    article.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :article
  end
end
