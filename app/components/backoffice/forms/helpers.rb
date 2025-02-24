module Backoffice
module Forms
module Helpers
  def text_control(*args, **kwargs)
    render case args
    in [Symbol | String => attribute_name, value]
      TextControl.new(attribute_name:, value:, **kwargs)
    in [model, attribute_name]
      TextControl.new(**derived_options(model, attribute_name), **kwargs)
    end
  end

  def number_control(*args, **kwargs)
    render case args
    in [Symbol | String => attribute_name, value]
      NumberControl.new(attribute_name:, value:, **kwargs)
    in [model, attribute_name]
      NumberControl.new(**derived_options(model, attribute_name), **kwargs)
    end
  end

  def radio_control(*args, **kwargs)
    render case args
    in [Symbol | String => attribute_name, value]
      RadioControl.new(attribute_name:, value:, **kwargs)
    in [model, attribute_name]
      RadioControl.new(**derived_options(model, attribute_name), **kwargs)
    end
  end

  def validation_errors(*args, **kwargs)
    render case args
    in [Array => messages]
      ValidationErrors.new(messages:, **kwargs)
    in [model, attribute_name]
      ValidationErrors.new(messages: model.errors.full_messages_for(attribute_name), **kwargs)
    end
  end

  private

  def to_namespace(...)
    Namespace.from(...)
  end

  def derived_options(model, attribute_name)
    {
      attribute_name: attribute_name,
      value: model.public_send(attribute_name),
      errors: model.errors.full_messages_for(attribute_name),
      label: human_attribute_name(model, attribute_name)
    }
  end
end
end
end
