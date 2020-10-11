class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    return if user.nil?

    @user = user

    # need to restrict to company
    can :manage, :all if user.global_admin?

    can :read, Project, id: user_project_ids
    can %i[update destroy], Project, project_users: { user_id: user.id, admin: true }

    can :read, Ticket, project_id: user_project_ids
    can :crud, Ticket, created_by_id: user.id, project_id: user_project_ids

    can :read, Article, project_id: user_project_ids
    can :crud, Article, user_id: user.id, project_id: user_project_ids

    # may need to update to only allow project admins to create
    can :manage, ProjectUser, project: { id: user_project_ids }

    # might not working when viewing others comments
    can :crud, Comment, user_id: user.id

    can :read, Schedule, project: { id: user_project_ids }
    can :crud, Schedule, project_users: { user_id: user.id, admin: true }

    can :crud, Contact, user_id: user.id

    can :manage, AlertSetting, user_id: user.id, project: { id: user_project_ids }
  end

  private

  def user_project_ids
    @user.projects.pluck(:id)
  end
end
