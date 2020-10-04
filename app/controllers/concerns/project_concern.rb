module ProjectConcern
  extend ActiveSupport::Concern

  def project_create_form
    initialize_and_authorize_project
    CreateProjectForm.new create_project_form_params.merge(project: @project)
  end

  def project_edit_form(project)
    EditProjectForm.new edit_project_form_params.merge(project: project)
  end

  private

  def initialize_and_authorize_project
    @project = Project.new(user: current_user, company: current_user.company)
    authorize! :create, @project
  end

  def create_project_form_params
    params.require(:create_project_form).permit(CreateProjectForm.accessible_attributes)
  end

  def edit_project_form_params
    params.require(:edit_project_form).permit(EditProjectForm.accessible_attributes)
  end
end
