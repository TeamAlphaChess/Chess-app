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
    it 'should return true if the current user forfeits a game' do
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)

      get :forfeit, id: game.id
      expect(user.forfeit).to eq true
    end

    it 'should return false if the other user in the game tries to forfeit if it is not their turn' do
      user = FactoryGirl.create(:user)
      second_user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)

      get :forfeit, id: game.id
      expect(second_user.forfeit).to eq false

    end

    it 'should increment the other players games_won count by 1 when forfeiting' do
    end

    it 'should return false if a user tries to forfeit a game they are not a part of' do
      # user = FactoryGirl.create(:user)
      # sign_in user
      # expect(game.user).to eq(user)
    end
  end
end
