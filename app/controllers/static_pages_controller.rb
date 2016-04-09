# Controller for static html content pages
class StaticPagesController < ApplicationController
  before_action :destroy_session_if_user_logged_in, only: [:show]
  include HighVoltage::StaticPage
  layout :layout_for_page




  def show
    if valid_page?
      render template: "static_pages/#{params[:id]}"
    else
      render file: 'public/404.html', status: 404
    end
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

  def valid_page?
    File.exist?(
      Pathname.new(
        File.join(Rails.root, "app/views/static_pages/#{params[:id]}.html.erb")
      )
    )
  end
end
