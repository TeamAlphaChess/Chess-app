class Users::SessionsController < Devise::SessionsController

  clear_respond_to
  respond_to :json
  # def new
  #   super
  # end

  # def create
  #   super
  # end
end
