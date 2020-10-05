module Wizard
  class BaseStep
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    attr_accessor :user, :post_params, :completed

    def save
      update_form.submit ? complete : false
    end

    def display_errors
      errors.full_messages.to_sentence
    end

    private

    def complete
      self.completed = true
    end
  end
end
