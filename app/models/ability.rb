class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    @user = user

    global_admin_cans(user)

    can :read, Project, id: user_project_ids
    can %i[update destroy], Project, project_users: { user_id: user.id, admin: true }

    can :read, Ticket, project_id: user_project_ids
    can :manage, Ticket, user_id: user.id, project_id: user_project_ids

    can :read, Article, project_id: user_project_ids
    can :manage, Article, user_id: user.id, project_id: user_project_ids

    # may need to update to only allow project admins to create
    can :manage, ProjectUser, project: { id: user_project_ids }

    # might not working when viewing others comments
    can :manage, Comment, user_id: user.id

    can :read, Schedule, project: { id: user_project_ids }
    can :manage, Schedule

    can :manage, Contact, user_id: user.id

    can :manage, AlertSetting, user_id: user.id, project: { id: user_project_ids }
  end

  private

  def global_admin_cans(user)
    can :manage, Project if user.global_admin?
    can :manage, Schedule if user.global_admin?
  end

  def user_project_ids
    @user.projects.pluck(:id)
  end
end
