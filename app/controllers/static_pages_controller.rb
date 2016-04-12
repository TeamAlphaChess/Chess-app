# frozen_string_literal: true
# Controller for static html content pages
class StaticPagesController < ApplicationController
  include HighVoltage::StaticPage
  layout :layout_for_page

  def show
    sign_out(current_user) if user_signed_in? && params[:id] == 'home'
    render template: "static_pages/#{params[:id]}"
  end

  private

  def layout_for_page
    'application'
  end
end
