class CreateCommentForm < BaseForm
  attr_accessor :content, :user, :commentable
  attr_writer :comment

  nested_attributes :content, :user, :commentable, to: :comment

  accessible_attr :content

  def comment
    @comment ||= Comment.new
  end

  def _submit
    comment.save!
  end
end
