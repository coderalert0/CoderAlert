class InviteUserForm < BaseForm
  attr_accessor :first_name, :last_name, :email, :project_ids, :company

  accessible_attr :first_name, :last_name, :email, project_ids: []

  validates_presence_of :first_name, :last_name, :email

  def _submit
    ActiveRecord::Base.transaction do
      user = User.invite!(first_name: first_name, last_name: last_name, email: email, company: company)
      projects = Project.find(project_ids)

      projects.each do |project|
        ProjectUser.find_or_create_by(user: user, project: project)
      end
    end
  end

  alias save submit
end
