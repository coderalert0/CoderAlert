class BaseForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  # include EmailSending
  # include ArgsKeyFirst

  def display_errors
    errors.full_messages.to_sentence
  end

  def submit
    if valid?
      _submit
    else
      _handle_invalid_form
    end
  end

  def _submit
    not_implemented
  end

  def _handle_invalid_form
    false
  end

  def filter_blank(item)
    item.blank? ? nil : item
  end
end
