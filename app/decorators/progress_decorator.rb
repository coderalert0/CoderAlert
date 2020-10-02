class ProgressDecorator < ApplicationDecorator
  delegate_all

  def display
    "Step #{current_step} of #{total_steps} (we promise it'll be quick!)"
  end
end
