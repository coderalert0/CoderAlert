class AddCurrentWelcomeStepToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_welcome_step, :string, default: 'project'
  end
end
