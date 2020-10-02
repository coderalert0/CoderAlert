class Progress
  include ActiveModel::Model
  include Draper::Decoratable

  attr_accessor :current_step, :total_steps
end
