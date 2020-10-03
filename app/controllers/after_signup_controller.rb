class AfterSignupController < ApplicationController
  layout 'welcome_wizard'

  include Wicked::Wizard
  include ProjectConcern
  include ScheduleConcern
  include InviteUsersConcern

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
      @form = project_create_form
      session[:project_id] = @form.project.id if @form.save
      render_wizard @form.project

    when :invite_users
      @form = invite_users_create_form
      render_wizard @form

    when :create_schedule
      @form = schedule_create_form
      render_wizard @form
    end
  end

  private

  def initialize_progress
    return unless wizard_steps.any? && wizard_steps.index(step).present?

    current_step = wizard_steps.index(step) + 1
    total_steps = wizard_steps.count

    @progress = Progress.new(current_step: current_step, total_steps: total_steps).decorate
  end
end
