module Users
  class PasswordsController < Devise::PasswordsController
    include DeviseConcern

    private

    def after_sign_in_path_for(user)
      devise_after_path(user)
    end
  end
end
