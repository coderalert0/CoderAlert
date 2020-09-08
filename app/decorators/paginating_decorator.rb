class PaginatingDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value

  delegate :model, to: :object

  delegate :model_name, to: :object
end
