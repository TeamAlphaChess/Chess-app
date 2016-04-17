class UsersController < ApplicationController
  

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @avatar = Avatar.new
  end

  def edit
    # if @user != current_user
    #   return render text: 'Not Allowed', status: :forbidden
    # end
  end

  helper_method :current_user
  def current_user
    @current_user ||= User.find(params[:id])
  end
end
