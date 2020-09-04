class Module
  def delegate_read_write(*fields)
    options = fields.extract_options!
    delegate(*(fields.flat_map { |attr| [attr, "#{attr}=".to_sym] }), options)
  end

  def validates_model(obj, options = {})
    add_validation(obj, options[:prefix], options[:skip_validation])
  end

  def nested_attributes(*fields, options)
    read_only = !(!options[:read_only])
    options[:prefix] = options[:to] if options[:prefix] == true

    if read_only
      delegate(*fields, options)
    else
      delegate_read_write(*fields, options)
    end
    define_collection_method(options.delete(:attributes) || "#{options[:to]}_attributes", fields, options[:prefix])
    add_validation(options[:to], options[:prefix], options[:skip_validation])
  end

  def accessible_attr(*params)
    define_singleton_method :accessible_attributes do |args = {}|
      ((defined?(superclass.accessible_attributes) ? superclass.accessible_attributes(args) : []) + params).uniq
    end
  end

  private

  # define singleton function to retrieve the set of fields as symbols and as strings
  def define_collection_method(function_name, fields, prefix)
    define_singleton_method(function_name) do
      if prefix.nil?
        fields
      else
        fields.map { |field| "#{prefix}_#{field}".to_sym }
      end
    end

    define_singleton_method("#{function_name}_to_s") do
      send(function_name).map(&:to_s)
    end
  end

  # add validation for nested objects
  def add_validation(target, prefix, skip_validation)
    validation_method_name = "#{target}_validation"

    define_method(validation_method_name) do
      Rails.logger.debug("Running ##{validation_method_name}")
      nested_object = send target
      valid = skip_validation.present? && send(skip_validation) ? true : nested_object.valid?
      unless valid
        nested_object.errors.messages.each do |field, messages|
          errors.messages["#{prefix ? "#{prefix}_" : ''}#{field}".to_sym] = messages
        end
      end
    end

    class_eval do
      validate validation_method_name.to_sym
    end
  end

  def use_superclass_param_key
    class_eval do
      def self.model_name
        @model_name ||= begin
          model_name = super
          model_name.instance_variable_set(:@param_key, superclass.model_name.param_key)
          model_name.instance_variable_set(:@human, superclass.model_name.human)
          model_name
        end
      end
    end
  end
end
