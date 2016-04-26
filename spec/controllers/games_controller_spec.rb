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
      expect(game.forfeit(user)).to eq true
    end

    it 'should increment the other players games_won count by 1 when forfeiting' do
      user = FactoryGirl.create(:user)
      second_user = FactoryGirl.create(:user)
      sign_in user
      # sign_in second_user
      game = FactoryGirl.create(:game)
      game.white_player_id = user.id
      game.black_player_id = second_user.id
      second_user.update_attributes(games_won: 0)
      game.current_player_turn_id = game.white_player_id
      game.forfeit(user)
      expect(second_user.reload.games_won).to eq 1
    end
  end
end
