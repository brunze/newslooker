module Backend
module Form
module Controls
  def text_control(*args, **kwargs)
    render case args
    in [Symbol | String => attribute_name, value]
      SimpleInputControl.new(input_type: :text, attribute_name:, value:, **kwargs)
    in [model, attribute_name]
      SimpleInputControl.new(input_type: :text, **derived_options(model, attribute_name), **kwargs)
    end
  end

  def number_control(*args, **kwargs)
    render case args
    in [Symbol | String => attribute_name, value]
      SimpleInputControl.new(input_type: :number, attribute_name:, value:, **kwargs)
    in [model, attribute_name]
      SimpleInputControl.new(input_type: :number, **derived_options(model, attribute_name), **kwargs)
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

  def human_attribute_name(model, attribute_name)
    if model.class.respond_to?(:human_attribute_name)
      # For some reason the default translation helper is ignoring the
      # `i18n.raise_on_missing_translations` setting so I have to force it here.
      model.class.human_attribute_name(attribute_name, raise: Rails.configuration.i18n.raise_on_missing_translations)
    else
      t(".#{attribute_name}")
    end
  end
end
end
end
