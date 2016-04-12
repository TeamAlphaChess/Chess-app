# frozen_string_literal: true
require 'rails_helper'
RSpec.describe StaticPagesController, type: :controller do
  describe 'GET root_path' do
    it 'renders the static home page on visiting the website' do
      expect(get: root_url(subdomain: nil)).to route_to(
        controller: 'static_pages',
        action: 'show',
        id: 'home')
    end
  end
end
