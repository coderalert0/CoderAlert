class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    return if user.nil?

    @user = user

    can :read, Project, id: user_project_ids
    can :crud, Project, user_id: user.id

    can :read, Ticket, project_id: user_project_ids
    can :crud, Ticket, created_by_id: user.id, project_id: user_project_ids

    can :read, Article, project_id: user_project_ids
    can :crud, Article, user_id: user.id, project_id: user_project_ids

    can :manage, ProjectUser

    # might not working when viewing others comments
    can :crud, Comment, user_id: user.id

    can :read, Schedule, project: { id: user_project_ids }
    can :crud, Schedule, user_id: user.id, project: { id: user_project_ids }

    can :crud, Contact, user_id: user.id

    can :manage, AlertSetting, user_id: user.id, project: { id: user_project_ids }
  end

  private

  def user_project_ids
    @user.projects.pluck(:id)
  end
end
