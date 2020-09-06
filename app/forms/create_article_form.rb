class CreateArticleForm < BaseForm
  attr_accessor :title, :description, :user, :project
  attr_writer :article

  nested_attributes :title, :description, :user, :project, to: :article

  accessible_attr :title, :description

  def article
    @article ||= Article.new
  end

  def _submit
    article.save!
  end
end
