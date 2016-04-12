# Actions here will be included in all other
# controllers that inherit from this controller.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticate_user!(_options = {})
    redirect_to root_path unless user_signed_in?
  end

  def after_sign_in_path_for(_resource)
    games_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end
end
