# frozen_string_literal: true
require 'rails_helper'
RSpec.describe StaticPagesController, type: :controller do
  describe 'GET root_path' do
    it 'renders the home page' do
      expect(get: root_url(subdomain: nil)).to route_to(
        controller: 'static_pages',
        action: 'show',
        id: 'home')
    end
  end

  describe 'static_pages#show' do
    it 'should raise 404 if page not found' do
      get :show, id: 'non_existing_page123'
      expect(response).to have_http_status(404)
      expect(response).to render_template(file: "#{Rails.root}/public/404.html")
    end
  end

  # TODO: implement test for root/wrongURL
  # Current test exists for root/static_pages/wrongURL
end
