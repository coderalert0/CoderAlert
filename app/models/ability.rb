class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    return if user.nil?

    @user = user
    @project_user_ids = user.projects.pluck(:id)
    @company_user_ids = user.company.users.pluck(:id)

    global_admin_cans
    project_user_cans
    resource_owner_cans
    project_user_admin_cans
  end

  def can?(action, subject, *extra_args)
    subject_arg = subject.is_a?(Draper::Decorator) ? subject.model : subject
    super(action, subject_arg, *extra_args)
  end

  def authorize!(action, subject, *extra_args)
    subject_arg = subject.is_a?(Draper::Decorator) ? subject.model : subject
    super(action, subject_arg, *extra_args)
  end

  private

  def global_admin_cans
    can :create, Project if @user.global_admin?
  end

  def project_user_cans
    can :read, Project, id: @project_user_ids
    can %i[read update], Ticket, project: { id: @project_user_ids }
    can %i[read update], Article, project: { id: @project_user_ids }
    can :read, ProjectUser, project: { id: @project_user_ids }
    can :read, Comment, commentable: { project: { id: @project_user_ids } }
    can :read, Schedule, project: { id: @project_user_ids }
    can :read, Contact, user: { id: @user.id, projects: { id: @project_user_ids } }
    can :read, User, projects: { id: @project_user_ids }
  end

  def resource_owner_cans
    can :crud, Ticket, user_id: @user.id, project: { id: @project_user_ids }
    can :crud, Article, user_id: @user.id, project: { id: @project_user_ids }
    can :crud, Comment, user_id: @user.id, commentable: { project: { id: @project_user_ids } }
    can :crud, Contact, user_id: @user.id
    can %i[read update], AlertSetting, user_id: @user.id, project: { id: @project_user_ids }
  end

  def project_user_admin_cans
    can :update, Project, project_users: { user_id: @user.id, admin: true }
    can :crud, ProjectUser, project: { project_users: { user_id: @user.id, admin: true } }
    can :permission, ProjectUser, user_id: @company_user_ids
    can :crud, Schedule, project: { project_users: { user_id: @user.id, admin: true } }
    can %i[create update], Authorization, project: { project_users: { user_id: @user.id, admin: true } }
  end
end
