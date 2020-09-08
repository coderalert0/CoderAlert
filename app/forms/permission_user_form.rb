class PermissionUserForm < BaseForm
  attr_accessor :user, :project

  accessible_attr :user

  def _submit
    user = User.find(@user)
    project_user = project.project_users.build(user: user)
    project_user.save!
  end

  private

  def initialize(args = {})
    self.user = User.find(args[:user]) if args[:user]
    super
  end
end
