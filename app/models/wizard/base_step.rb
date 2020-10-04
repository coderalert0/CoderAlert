module Wizard
  class BaseStep
    include ActiveModel::Model

    attr_accessor :user, :post_params, :completed

    def save_data
      update_form.submit ? complete : false
    end
    alias save save_data

    private

    def complete
      self.completed = true
    end
  end
end
