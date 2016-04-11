# Controller for static html content pages
class StaticPagesController < ApplicationController
  before_action :destroy_session_if_user_logged_in, only: [:show]
  include HighVoltage::StaticPage
  layout :layout_for_page

  def show
    render template: "static_pages/#{params[:id]}"
  end

  private

  def destroy_session_if_user_logged_in
    if user_signed_in? && :id == 'home'
      sign_out_and_redirect(current_user)
    end
  end

  def layout_for_page
    'application'
  end
end
