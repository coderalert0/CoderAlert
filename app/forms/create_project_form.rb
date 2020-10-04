class CreateProjectForm < BaseForm
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
      ProjectUser.find_or_create_by(user: project.user, project: project)
    end
  end

  alias save submit

  private

  def initialize(args = {})
    super args_key_first args, :project
  end
end
