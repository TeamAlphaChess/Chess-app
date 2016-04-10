class Users::RegistrationsController < Devise::RegistrationsController
  clear_respond_to
  respond_to :json
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name)
  end

end
