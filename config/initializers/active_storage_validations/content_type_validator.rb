module ActiveStorageValidations
  class ContentTypeValidator < ActiveModel::EachValidator # :nodoc:
    def validate_each(record, attribute, value)
      return true if !record.send(attribute).attached? || types.empty?

      files = Array.wrap(record.send(attribute))

      errors_options = { authorized_types: types_to_human_format }
      errors_options[:message] = options[:message] if options[:message].present?

      files.each do |file|
        next if is_valid?(file)

        errors_options[:content_type] = content_type(file)
        record.errors.add(attribute, :content_type_invalid, errors_options)

        file.purge
        break
      end
    end
  end
end
