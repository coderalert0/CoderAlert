module Wizard
  class BaseStep
    include ActiveModel::Model

    attr_accessor :user, :post_params
  end
end
