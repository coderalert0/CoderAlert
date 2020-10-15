module ApplicationHelper
  module BootstrapExtension
    def submit_button
      submit_tag I18n.t(:submit), class: 'btn btn-primary'
    end

    def next_button
      submit_tag I18n.t(:next, scope: :welcome_wizard), class: 'btn btn-primary'
    end

    def back_button
      link_to I18n.t(:back, scope: :welcome_wizard), previous_wizard_path, class: 'btn btn-outline-dark'
    end
  end

  include BootstrapExtension
end
