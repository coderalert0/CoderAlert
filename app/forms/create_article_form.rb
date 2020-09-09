class CreateArticleForm < BaseForm
  attr_accessor :title, :content, :user, :project
  attr_writer :article

  nested_attributes :title, :content, :user, :project, to: :article

  accessible_attr :title, :content

  def article
    @article ||= Article.new
  end

  def _submit
    article.save!
  end
end
