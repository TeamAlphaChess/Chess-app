class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  helper_method :current_user
  def current_user
    @current_user ||= User.find(params[:id])
  end
end
