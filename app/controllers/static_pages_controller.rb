# frozen_string_literal: true
# Controller for static html content pages
class StaticPagesController < ApplicationController
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

  # Note that this is only for static pages.
  # Any pages where the user is logged in
  # will follow the application.html.erb
  # layout.
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
