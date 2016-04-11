class Users::SessionsController < Devise::SessionsController
  clear_respond_to
  respond_to :json

  def new
  end

  protected

end
