class AfterSignupController < ApplicationController
  layout 'welcome_wizard'

  include Wicked::Wizard

  before_action :initialize_progress, only: [:show]

  steps :create_project, :invite_users, :create_schedule

  def show
    case step

    when :create_project
      @form = CreateProjectForm.new

    when :invite_users
      @form = InviteUserForm.new
      @projects = current_user.company.projects

    when :create_schedule
      @form = CreateScheduleForm.new
    end

    render_wizard
  end

  def update
    case step

    when :create_project
      @form = CreateProjectForm.new create_project_form_params.merge(user: current_user)
      session[:project_id] = @form.project.id if @form.save
      render_wizard @form.project

    when :invite_users
      @form = InviteUserForm.new invite_users_form_params.merge(company: current_user.company)
      render_wizard @form

    when :create_schedule
      @form = CreateScheduleForm.new create_schedule_form_params.merge(project: @current_project)
      render_wizard @form
    end
  end

  private

  def create_project_form_params
    params.require(:create_project_form).permit(CreateProjectForm.accessible_attributes)
  end

  def invite_users_form_params
    form_params = params.require(:invite_user_form).permit(InviteUserForm.accessible_attributes)
    form_params[:project_ids].reject! { |project_id| project_id if project_id == '' }
    form_params
  end

  def create_schedule_form_params
    params.require(:create_schedule_form).permit(CreateScheduleForm.accessible_attributes)
  end

  def initialize_progress
    if wizard_steps.any? && wizard_steps.index(step).present?
      current_step = wizard_steps.index(step) + 1
      total_steps = wizard_steps.count

      @progress = Progress.new(current_step: current_step, total_steps: total_steps).decorate
    end
  end
end
