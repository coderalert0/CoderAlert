class AfterSignupController < ApplicationController
  rescue_from Wicked::Wizard::InvalidStepError do
    redirect_to wizard_path(current_user.current_welcome_step)
  end

  include Wicked::Wizard
  include SlackConcern

  skip_before_action :load_context

  layout 'welcome_wizard'

  before_action :initialize_progress, only: [:show]
  before_action :load_and_authorize_resources

  after_action :after_success_step, only: :update

  steps :project, :invite_user, :schedule, :slack

  def show
    skip_step if slack_step_complete?
    @form = send("show_#{step}_form") if project_step? || invite_user_step?
    @slack_redirect_url = slack_redirect_url if slack_step?
    render_wizard
  end

  def update
    @form = send("update_#{step}_form")
    render_wizard @form
  end

  private

  def load_and_authorize_resources
    load_and_authorize_project
  end

  def load_and_authorize_project
    @project = if session['project_id']
                 Project.find(session['project_id'])
               else
                 Project.new(user: current_user, company: current_user.company)
               end
    # authorize! :create, @project
  end

  def users_step?
    step == :invite_user
  end

  def project_step?
    step == :project
  end

  def invite_user_step?
    step == :invite_user
  end

  def slack_step?
    step == :slack
  end

  def slack_step_complete?
    step == :slack && @project.slack_authorization.present?
  end

  def after_success_step
    return unless @form.success == true

    current_user.update(current_welcome_step: next_step)

    return if users_step?

    session["#{step}_id".to_sym] = @form.send(step.to_s).id
  end

  def show_project_form
    CreateProjectForm.new(project: @project)
  end

  def update_project_form
    CreateProjectForm.new params.require(:create_project_form)
                                .permit(CreateProjectForm.accessible_attributes)
                                .merge(project: @project)
  end

  def show_invite_user_form
    InviteUserForm.new
  end

  def update_invite_user_form
    InviteUserForm.new params
      .require(:invite_user_form)
      .permit(InviteUserForm.accessible_attributes)
      .merge(company: current_user.company, project_ids: [@project.id.to_s])
  end

  def initialize_progress
    step_index = wizard_steps.index(step)

    return unless step_index.present?

    current_step = step_index + 1
    total_steps = wizard_steps.count

    @progress = Progress.new(current_step: current_step, total_steps: total_steps).decorate
  end
end
