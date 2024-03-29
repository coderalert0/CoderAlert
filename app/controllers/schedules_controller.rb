class SchedulesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  before_action :load_time_zone, only: %i[new edit]
  before_action :populate_select_users, only: %i[new edit]
  before_action :disable_browser_caching, only: :edit

  def index; end

  def show
    gon.url = project_schedule_path(@project, @schedule, format: :json)
  end

  def new
    @form = CreateScheduleForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = t(:create, scope: %i[schedule flash])
      redirect_to project_schedule_path(@project, @schedule)
    else
      flash.alert = @form.display_errors
      populate_select_users
      render :new
    end
  end

  def edit
    @form = EditScheduleForm.new schedule: @schedule
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = t(:update, scope: %i[schedule flash])
      redirect_to project_schedule_path(@project, @schedule)
    else
      flash.alert = @form.display_errors
      populate_select_users
      render :edit
    end
  end

  def destroy
    if @schedule.destroy
      flash.notice = t(:destroy, scope: %i[schedule flash])
      redirect_to project_schedules_path
    else
      flash.alert = t(:destroy_error, scope: %i[schedule flash])
      render :show
    end
  end

  private

  def create_form
    CreateScheduleForm.new form_params(CreateScheduleForm).merge(schedule: @schedule, user: current_user)
  end

  def edit_form
    EditScheduleForm.new form_params(EditScheduleForm).merge(schedule: @schedule, user: current_user)
  end

  def populate_select_users
    user_ids = @schedule.schedule_users.pluck(:user_id)
    @select_users = @project.users.confirmed.where.not(id: user_ids)
  end

  def load_time_zone
    gon.time_zone = ActiveSupport::TimeZone::MAPPING[current_user.time_zone].to_s
  end
end
