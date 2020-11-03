module ActiveStorageValidations
  class SizeValidator < ActiveModel::EachValidator # :nodoc:
    def validate_each(record, attribute, _value)
      return true unless record.send(attribute).attached?

      files = Array.wrap(record.send(attribute))

      errors_options = {}
      errors_options[:message] = options[:message] if options[:message].present?

      files.each do |file|
        next if content_size_valid?(file.blob.byte_size)

        errors_options[:file_size] = number_to_human_size(file.blob.byte_size)
        record.errors.add(attribute, :file_size_out_of_range, errors_options)

        file.purge
        break
      end
    end
  end
end