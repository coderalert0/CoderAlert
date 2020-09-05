class AddCompanyToProjectsAndUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :company, null: false
    add_reference :users, :company, null: false
  end
end
