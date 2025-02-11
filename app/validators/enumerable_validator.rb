class EnumerableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    record.errors.add(attribute, :blank) and return if values.nil? && !options[:allow_nil]

    values.each do |value|
      options.fetch(:each).each_pair do |validator_name, validator_args|
        validator_options = { attributes: attribute }
        validator_options.merge!(validator_args) if validator_args.is_a?(Hash)

        validator = validator_class(validator_name).new(validator_options)
        validator.validate_each(record, attribute, value)
      end
    end
  end

  private

  def validator_class(validator_name)
    validator_class_name = "#{validator_name.to_s.camelize}Validator"
    begin
      validator_class_name.constantize
    rescue NameError
      "ActiveModel::Validations::#{validator_class_name}".constantize
    end
  end
end
