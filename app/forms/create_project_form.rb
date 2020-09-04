class CreateProjectForm < BaseForm
  attr_accessor :name
  attr_writer :project

  nested_attributes :name, to: :project

  accessible_attr :name

  validates_presence_of :name

  def project
    @project ||= Project.new
  end

  def _submit
    project.save!
  end
end
