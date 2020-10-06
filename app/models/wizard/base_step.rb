module Wizard
  class BaseStep
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    attr_accessor :user, :post_params
  end
end
