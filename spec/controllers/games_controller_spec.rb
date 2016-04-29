# frozen_string_literal: true
require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#show action' do
    it 'should successfully show the page if the game is found' do
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)

      get :show, id: game.id
      expect(response).to have_http_status(:success)
    end
  end
end
