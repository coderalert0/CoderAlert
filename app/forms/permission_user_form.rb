class PermissionUserForm < BaseForm
  attr_accessor :user, :project

  accessible_attr :user
end
