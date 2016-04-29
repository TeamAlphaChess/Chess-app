# frozen_string_literal: true
require 'rails_helper'
require 'spec_helper'

RSpec.describe Game, type: :model do
  describe 'status' do
    it 'should not have an open seat available if both players present' do
      FactoryGirl.create(:game)
      open_games = Game.list_available_games
      expect(open_games.length).to eq(0)
    end

    it 'should query a maximum of 20 games' do
      FactoryGirl.create_list(:game, 21, black_player_id: nil)
      open_games = Game.list_available_games
      expect(open_games.length).to eq(20)
    end

    it 'should return 0 out of 2 created games if 1 game is full, while only white is present in other game' do
      FactoryGirl.create(:game, white_player_id: nil)
      FactoryGirl.create(:game)
      open_games = Game.list_available_games
      expect(open_games.length).to eq(0)
    end

    it 'should return 1 out of 2 created games if 1 game is full, while only white is present in other game' do
      FactoryGirl.create(:game, black_player_id: nil)
      FactoryGirl.create(:game)
      open_games = Game.list_available_games
      expect(open_games.length).to eq(1)
    end
  end

  describe 'populate gameboard' do
    it 'should create 32 pieces' do
      game = FactoryGirl.create(:game)
      expect(game.reload.pieces.count).to eq 32
    end
  end

  describe 'forfeit method' do
    it 'should increment the other players games_won count by 1 when forfeiting' do
      user = FactoryGirl.create(:user)
      second_user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game)
      game.white_player_id = user.id
      game.black_player_id = second_user.id
      second_user.update_attributes(games_won: 0)
      game.current_player_turn_id = game.white_player_id
      game.forfeit(user)
      expect(second_user.reload.games_won).to eq 1
    end

    it 'should return true if the current user forfeits a game' do
      user = FactoryGirl.create(:user)
      second_user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_player_id: user.id, black_player_id: second_user.id)

      game.white_player_id = user.id
      game.current_player_turn_id = game.white_player_id

      expect(game.forfeit(user)).to eq true
    end
  end
end
