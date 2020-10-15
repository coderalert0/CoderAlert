class ApplicationDecorator < Draper::Decorator
  def self.collection_decorator_class
    PaginatingDecorator
  end

  def created_at_display
    created_at.to_formatted_s(:custom_long_ordinal)
  end

  def updated_at_display
    updated_at.to_formatted_s(:custom_long_ordinal)
  end
end
