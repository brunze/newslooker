class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pagy::UrlHelpers

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Basic authentication will do for now.
  http_basic_authenticate_with(
    name: Rails.application.credentials.basic_auth!.username!,
    password: Rails.application.credentials.basic_auth!.password!,
  ) unless Rails.env.test?
end
