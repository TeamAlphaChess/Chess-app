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

  describe 'stalemate?' do
    it 'should return true if the only legal moves put you in check(whites move)' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 7, game_id: game.id)
      FactoryGirl.create(:king, color: 'black', current_row_index: 2, current_column_index: 6, game_id: game.id)
      FactoryGirl.create(:queen, color: 'black', current_row_index: 1, current_column_index: 5, game_id: game.id)
      expect(game.stalemate?('white')).to eq true
    end
  end

  describe 'in_check?' do
    it 'should return true if the white king is in check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 7, game_id: game.id)
      FactoryGirl.create(:bishop, color: 'black', current_row_index: 7, current_column_index: 0, game_id: game.id)
      expect(game.in_check?('white')).to eq true
    end

    it 'should return false if the white king is in check' do
      game = FactoryGirl.create(:game)
      expect(game.in_check?('white')).to eq false
    end
  end
end
