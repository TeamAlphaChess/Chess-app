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

    it 'should query a maximum of 10 games' do
      FactoryGirl.create_list(:game, 11, black_player_id: nil)
      open_games = Game.list_available_games
      expect(open_games.length).to eq(10)
    end

    it 'should return 0 out of 2 created games if 1 game is full, while only black is present in other game' do
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
end
