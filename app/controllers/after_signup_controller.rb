class AfterSignupController < ApplicationController
  include Wicked::Wizard

  skip_before_action :load_context

  layout 'welcome_wizard'

  before_action :initialize_progress, only: [:show]
  before_action :initialize_step
  after_action :after_success_step, only: :update, if: :step_completed?

  steps :project, :users, :schedule

  def show
    populate_show unless finish_step?
    render_wizard
  end

  def update
    populate_update
    render_wizard @wizard_step
  end

  private

  def populate_show
    @form = @wizard_step.show_form
    @projects = current_user.projects
    @current_project = Project.find(session[:project_id]) if session[:project_id]
  end

  def populate_update
    @wizard_step.post_params = params
    @form = @wizard_step.update_form
    @current_project = Project.find(session[:project_id]) if session[:project_id]
  end

  def initialize_step
    return if finish_step?

    step_args = if users_step?
                  { company: current_user.company }
                else
                  { step.to_s => send(step.to_s), :user => current_user }
                end

    @wizard_step = "Wizard::#{step.to_s.camelize}Step".constantize.new(step_args)
  end

  def finish_step?
    step == Wicked::FINISH_STEP
  end

  def users_step?
    step == :users
  end

  def project
    if session[:project_id]
      Project.find(session[:project_id])
    else
      Project.new(user: current_user, company: current_user.company)
    end
  end

  def schedule
    if session[:schedule_id]
      Schedule.find(session[:schedule_id]) if session[:schedule_id]
    else
      Schedule.new(user: current_user, project: project)
    end
  end

  def after_success_step
    session["#{step}_id".to_sym] = @wizard_step.send(step.to_s).id unless users_step?
  end

  def step_completed?
    @wizard_step.completed
  end

  def initialize_progress
    return unless wizard_steps.index(step).present?

    current_step = wizard_steps.index(step) + 1
    total_steps = wizard_steps.count

    @progress = Progress.new(current_step: current_step, total_steps: total_steps).decorate
  end
end
