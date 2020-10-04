class AfterSignupController < ApplicationController
  skip_before_action :load_context

  layout 'welcome_wizard'

  include Wicked::Wizard
  include ProjectConcern
  include ScheduleConcern
  include InviteUsersConcern

  before_action :initialize_progress, only: [:show]

  steps :project, :users, :schedule

  def show
    case step

    when :project
      @form = project_in_session? ? EditProjectForm.new(project: project) : CreateProjectForm.new

    when :users
      @form = InviteUserForm.new
      @projects = current_user.company.projects

    when :schedule
      @form = schedule_in_session? ? EditScheduleForm.new(schedule: schedule) : CreateScheduleForm.new
      @current_project = project
      flash[:notice] = 'Congratulations! You have completed the setup process'
    end

    render_wizard
  end

  def update
    case step

    when :project
      @form = project_in_session? ? project_edit_form(project) : project_create_form
      session[:project_id] = @form.project.id if @form.save

    when :users
      @form = invite_users_create_form

    when :schedule
      @current_project = project
      @form = schedule_in_session? ? schedule_edit_form(schedule) : schedule_create_form
      session[:schedule_id] = @form.schedule.id if @form.save
    end

    render_wizard @form
  end

  private

  def initialize_progress
    return unless wizard_steps.index(step).present?

    current_step = wizard_steps.index(step) + 1
    total_steps = wizard_steps.count

    @progress = Progress.new(current_step: current_step, total_steps: total_steps).decorate
  end

  def project_in_session?
    session[:project_id].present?
  end

  def schedule_in_session?
    session[:schedule_id].present?
  end

  def project
    Project.find(session[:project_id])
  end

  def schedule
    Schedule.find(session[:schedule_id])
  end
end
