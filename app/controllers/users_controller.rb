# frozen_string_literal: true
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @avatar = Avatar.new
  end

  helper_method :current_user
  def current_user
    @current_user ||= User.find(params[:id])
  end
end
