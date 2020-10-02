class CreateProjectForm < BaseForm
  attr_accessor :user
  attr_writer :project

  nested_attributes :name, :company, :key, to: :project

  accessible_attr :name, :key

  def key=(value)
    project.key = value.present? ? value.upcase : project.name.split.map(&:first).join.upcase
  end

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

  alias save submit

  private

  def initialize(args = {})
    self.company = args[:user].company if args[:user]
    super
  end
end
