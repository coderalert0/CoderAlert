class CreateProjectForm < BaseForm
  attr_accessor :name, :user
  attr_writer :project

  nested_attributes :name, :company, to: :project

  accessible_attr :name

  def project
    @project ||= Project.new
  end

  def _submit
    ActiveRecord::Base.transaction do
      project.save!
      project_user = project.project_users.build(user: @user)
      project_user.save!
    end
  end

  private

  def initialize(args = {})
    self.company = args[:user].company if args[:user]
    super
  end
end
