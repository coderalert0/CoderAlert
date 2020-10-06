class AfterSignupController < ApplicationController
  include Wicked::Wizard

  skip_before_action :load_context

  layout 'welcome_wizard'

  before_action :initialize_progress, only: [:show]
  before_action :initialize_step

  before_action :load_project
  after_action :after_success_step, only: :update

  steps :project, :users, :schedule

  def show
    populate_show unless finish_step?
    render_wizard
  end

  def update
    populate_update
    render_wizard @form
  end

  private

  def populate_show
    @projects = current_user.projects
    @form = @wizard_step.show_form
  end

  def populate_update
    @wizard_step.post_params = params
    @form = @wizard_step.update_form
  end

  def initialize_step
    return if finish_step?

    step_args = if users_step?
                  { company: current_user.company, project: project }
                else
                  { step.to_s => send(step.to_s) }
                end

    step_args = step_args.merge(user: current_user)

    @wizard_step = "Wizard::#{step.to_s.camelize}Step".constantize.new(step_args)
  end

  def users_step?
    step == :users
  end

  def schedule_step?
    step == :schedule
  end

  def finish_step?
    step == Wicked::FINISH_STEP
  end

  def project
    load_project_from_session || Project.new(user: current_user, company: current_user.company)
  end

  def schedule
    load_schedule_from_session || Schedule.new(user: current_user, project: project)
  end

  def load_project_from_session
    Project.find(session['project_id']) if session['project_id']
  end

  def load_schedule_from_session
    Schedule.find(session['schedule_id']) if session['schedule_id']
  end

  def load_project
    @current_project = load_project_from_session if schedule_step?
  end

  def after_success_step
    return if users_step?

    session["#{step}_id".to_sym] = @wizard_step.send(step.to_s).id
  end

  def initialize_progress
    return unless wizard_steps.index(step).present?

    current_step = wizard_steps.index(step) + 1
    total_steps = wizard_steps.count

    @progress = Progress.new(current_step: current_step, total_steps: total_steps).decorate
  end
end
