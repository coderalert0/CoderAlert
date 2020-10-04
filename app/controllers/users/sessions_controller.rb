module Users
  class SessionsController < Devise::SessionsController
    include DeviseConcern

    def create
      super
      flash.delete(:notice)
    end

    private

    def after_sign_in_path_for(user)
      devise_after_path(user)
    end
  end
end
