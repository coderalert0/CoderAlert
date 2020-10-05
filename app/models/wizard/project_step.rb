module Wizard
  class ProjectStep < BaseStep
    validates_model :project

    attr_accessor :project

    def show_form
      CreateProjectForm.new(project: project)
    end

    def update_form
      CreateProjectForm.new post_params.require(:create_project_form)
                                       .permit(CreateProjectForm.accessible_attributes)
                                       .merge(project: project)
    end

    def complete
      self.project = update_form.project
      super
    end

    def save
      project_validation
      super
    end
  end
end
