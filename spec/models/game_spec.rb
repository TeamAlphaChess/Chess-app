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
    it 'should return true for this stalemate' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      game.reload
      FactoryGirl.create(:king, color: 'black', current_row_index: 0, current_column_index: 0, game_id: game.id)
      FactoryGirl.create(:rook, color: 'white', current_row_index: 1, current_column_index: 7, game_id: game.id)
      FactoryGirl.create(:rook, color: 'white', current_row_index: 7, current_column_index: 1, game_id: game.id)
      expect(game.stalemate?('black')).to eq true
    end

    it 'should return false for this game since its not a stalemate' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      game.reload
      FactoryGirl.create(:king, color: 'black', current_row_index: 0, current_column_index: 0, game: game)
      FactoryGirl.create(:rook, color: 'black', current_row_index: 1, current_column_index: 7, game: game)
      FactoryGirl.create(:rook, color: 'white', current_row_index: 1, current_column_index: 6, game_id: game.id)
      FactoryGirl.create(:rook, color: 'white', current_row_index: 7, current_column_index: 1, game_id: game.id)
      expect(game.stalemate?('black')).to eq false
    end

    it 'should return true if the only legal moves put you in check(whites move)' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      game.reload
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 7, game_id: game.id)
      FactoryGirl.create(:king, color: 'black', current_row_index: 2, current_column_index: 6, game_id: game.id)
      FactoryGirl.create(:queen, color: 'black', current_row_index: 1, current_column_index: 5, game_id: game.id)
      expect(game.stalemate?('white')).to eq true
    end

    it 'should return true if for this stalemate(blacks move)' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      game.reload
      FactoryGirl.create(:king, color: 'black', current_row_index: 7, current_column_index: 2, game_id: game.id)
      FactoryGirl.create(:queen, color: 'white', current_row_index: 6, current_column_index: 0, game_id: game.id)
      FactoryGirl.create(:knight, color: 'white', current_row_index: 5, current_column_index: 2, game_id: game.id)
      expect(game.stalemate?('black')).to eq true
    end

    it 'should return false since this is the start of the game and it cannot be stalemate(whites move)' do
      game = FactoryGirl.create(:game)
      expect(game.stalemate?('white')).to eq false
    end

    it 'should return false since this is the start of the game and it cannot be stalemate(blacks move)' do
      game = FactoryGirl.create(:game)
      expect(game.stalemate?('black')).to eq false
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

  describe 'empty_spots' do
    it 'should return true for having 32 empty spots' do
      game = FactoryGirl.create(:game)
      expect(game.empty_spots.count).to eq 32
    end

    it 'should return true for having 34 empty spots' do
      game = FactoryGirl.create(:game)
      game.pieces.last.destroy
      game.pieces.last.destroy
      expect(game.reload.empty_spots.count).to eq 34
    end

    it 'should return true if the same spots are empty' do
      game = FactoryGirl.create(:game)
      empty_locations = [[2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7],
                         [3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7],
                         [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7],
                         [5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7]]
      expect(game.empty_spots).to eq empty_locations
    end
  end

  describe 'move_puts_king_in_check?' do
    it 'should return true since im moving the king into check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      king = FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 0, game_id: game.id)
      FactoryGirl.create(:rook, color: 'black', current_row_index: 7, current_column_index: 1, game_id: game.id)
      expect(game.move_puts_king_in_check?('white', king, 0, 1)).to eq true
    end

    it 'should return true since im moving a piece to cause check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 0, game_id: game.id)
      blocker = FactoryGirl.create(:rook, color: 'white', current_row_index: 1, current_column_index: 0, game_id: game.id)
      FactoryGirl.create(:rook, color: 'black', current_row_index: 7, current_column_index: 0, game_id: game.id)
      expect(game.move_puts_king_in_check?('white', blocker, 1, 5)).to eq true
      expect(blocker.current_row_index).to eq 1
      expect(blocker.current_column_index).to eq 0
    end

    it 'should return false since im moving a piece but it wont cause check' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      FactoryGirl.create(:king, color: 'white', current_row_index: 0, current_column_index: 0, game_id: game.id)
      blocker = FactoryGirl.create(:rook, color: 'white', current_row_index: 1, current_column_index: 0, game_id: game.id)
      FactoryGirl.create(:rook, color: 'black', current_row_index: 7, current_column_index: 1, game_id: game.id)
      expect(game.move_puts_king_in_check?('white', blocker, 1, 5)).to eq false
      game.reload
      expect(blocker.current_row_index).to eq 1
      expect(blocker.current_column_index).to eq 0
    end
  end
end
