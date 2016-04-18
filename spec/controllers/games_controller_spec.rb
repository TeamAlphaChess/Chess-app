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

  describe 'games#forfeit action' do
    it 'should allow the current user to forfeit a game' do
    end

    it 'should increment the other players games_won count by 1' do
    end

    it 'should return false if a user is not logged in' do
      # user = FactoryGirl.create(:user)
      # sign_in user

      # expect(game.user).to eq(user)
    end
end
