class ApplicationComponent < ViewComponent::Base
  private

  def human_attribute_name(model, attribute_name)
    if model.class.respond_to?(:human_attribute_name)
      # For some reason the default translation helper is ignoring the
      # `i18n.raise_on_missing_translations` setting so I have to force it here.
      model.class.human_attribute_name(attribute_name, raise: Rails.configuration.i18n.raise_on_missing_translations)
    else
      t(".#{attribute_name}")
    end
  end

  def render_slim(slim)
    Slim::Template.new { slim }.render(self).html_safe
  end

  def render_slim_template(path)
    Tilt.new("#{path}.html.slim").render(self).html_safe
  end
end
