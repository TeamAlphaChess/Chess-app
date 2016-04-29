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

  describe 'in_check?' do
    it 'should return true if the white king is in check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 7, game_id: game.id)
      FactoryGirl.create(:bishop, color: 'black', current_row_index: 7, current_column_index: 0, game_id: game.id)
      expect(game.in_check?('white')).to eq true
    end

    it 'should return false if king is not in check' do
      game = FactoryGirl.create(:game)
      expect(game.in_check?('white')).to eq false
    end
  end

  describe 'checkmate?' do
    it 'should return false if white king can move out of check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 7, game_id: game.id)
      expect(game.checkmate?('white')).to eq false
    end

    it 'should return false if black king can move out of check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'black', current_row_index: 7, current_column_index: 4, game_id: game.id)
      expect(game.checkmate?('black')).to eq false
    end

    it 'should return true if game if white king can\'t move out of check' do
      game = FactoryGirl.create(:game)
      # white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # white_queen = game.pieces.find_by_current_row_index_and_current_column_index(0, 3)
      # white_bishop = game.pieces.find_by_current_row_index_and_current_column_index(0, 5)
      # white_pawn3 = game.pieces.find_by_current_row_index_and_current_column_index(1, 3)
      game.pieces.find_by_current_row_index_and_current_column_index(1, 4).destroy
      # white_pawn1.update_attributes(current_row_index: nil, current_column_index: nil)
      # white_pawn2 = game.pieces.find_by_current_row_index_and_current_column_index(1, 5)
      black_queen = game.pieces.find_by_current_row_index_and_current_column_index(7, 3)
      black_queen.update_attributes(current_row_index: 4, current_column_index: 4)
      expect(game.checkmate?('white')).to eq true
    end

    it 'should return true if black king can\'t move out of check' do
      game = FactoryGirl.create(:game)
      # black_king = game.pieces.find_by_current_row_index_and_current_column_index(7, 4)
      # black_queen = game.pieces.find_by_current_row_index_and_current_column_index(7, 3)
      # black_bishop = game.pieces.find_by_current_row_index_and_current_column_index(7, 5)
      # black_pawn3 = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      game.pieces.find_by_current_row_index_and_current_column_index(6, 4).destroy
      # black_pawn1.update_attributes(current_row_index: nil, current_column_index: nil)
      # black_pawn2 = game.pieces.find_by_current_row_index_and_current_column_index(6, 5)
      white_queen = game.pieces.find_by_current_row_index_and_current_column_index(0, 3)
      white_queen.update_attributes(current_row_index: 4, current_column_index: 4)
      expect(game.checkmate?('black')).to eq true
    end
  end
end
