module ApplicationHelper
  module BootstrapExtension
    def submit_button
      submit_tag I18n.t(:submit), class: 'btn btn-primary'
    end

    def wizard_next_button
      submit_tag I18n.t(:next, scope: :welcome_wizard), class: 'btn btn-primary'
    end

    def wizard_schedule_next_button
      link_to I18n.t(:next, scope: :welcome_wizard), next_wizard_path, class: 'btn btn-primary'
    end

    def wizard_back_button
      link_to I18n.t(:back, scope: :welcome_wizard), previous_wizard_path, class: 'btn btn-outline-dark'
    end
  end

  include BootstrapExtension
end
