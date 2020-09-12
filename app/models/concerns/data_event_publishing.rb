module DataEventPublishing
  extend ActiveSupport::Concern

  included do
    include Wisper::Publisher
    enable_publishing
  end

  module ClassMethods
    def publish_prefix(prefix)
      @prefix = prefix unless prefix.blank?
    end

    def _publish_prefix
      @prefix ||= name.snakify
    end

    def publishing_enabled?
      @@publishing_enabled
    end

    def disable_publishing
      @@publishing_enabled = false
    end

    def enable_publishing
      @@publishing_enabled = true
    end

    def publish_on_updated_attribute(attribute, params = {})
      params[:when] ||= :after
      message = "#{attribute}_changed"

      case params[:when].to_sym
      when :after
        publish_on_updated_attribute_after attribute, message
      else
        publish_on_updated_attribute_around message
      end
    end

    def publishes_creation
      class_eval { after_create { |model| _publish model, 'created' } }
    end

    def publishes_updates
      class_eval { around_update { |model, block| _publish model, 'updated', block } }
    end

    def publishes_destruction
      class_eval { after_destroy { |model| _publish model, 'destroyed' } }
    end

    def publishes_lifecycle_events
      publishes_creation
      publishes_updates
      publishes_destruction
    end

    def publish_on_updated_attribute_around(message)
      class_eval { around_update { |model, block| _publish model, message, block } }
    end

    def publish_on_updated_attribute_after(attribute, message)
      class_eval do
        around_update do |model, block|
          changed = attribute_changed? attribute
          block.call
          _publish model, message if changed
        end
      end
    end
  end

  # TODO: refactor to use _publish and get rid of Publisher module
  def publish_state(transition)
    Rails.logger.debug { "publish #{_publish_model_name}_on_#{transition.to}" }
    publish "#{_publish_model_name}_on_#{transition.to}".to_sym, self
  end

  private

  def _publish_model_name
    self.class.name.snakify
  end

  def _publish(model, action, block = nil)
    unless self.class.publishing_enabled?
      block.call if block.present?
      return
    end

    event = "#{model.class._publish_prefix}_#{action}".to_sym
    Rails.logger.debug { "_publish #{event}, #{model}" }
    block.nil? ? publish(event, model) : publish(event, model, block)
  end
end
