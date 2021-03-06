# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Rook, type: :model do
  describe 'valid_move?' do
    it 'should allow a horizontal-right move' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      white_knight = game.pieces.find_by_current_row_index_and_current_column_index(0, 1)
      white_knight.update_attributes(current_row_index: nil, current_column_index: nil)
      expect(white_rook.valid_move?(0, 1)).to eq true
    end

    it 'should allow a horizontal-left move' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 7)
      white_knight = game.pieces.find_by_current_row_index_and_current_column_index(0, 6)
      white_knight.update_attributes(current_row_index: nil, current_column_index: nil)
      expect(white_rook.valid_move?(0, 6)).to eq true
    end

    it 'should allow a vertical-up move' do
      game = FactoryGirl.create(:game)
      black_rook = game.pieces.find_by_current_row_index_and_current_column_index(7, 0)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      black_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      expect(black_rook.valid_move?(6, 0)).to eq true
    end

    it 'should return false for a diagonal move' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 1)
      white_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      expect(white_rook.valid_move?(1, 1)).to eq false
    end

    it 'should return false for a move to a space with same color piece' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      expect(white_rook.valid_move?(1, 0)).to eq false
    end

    it 'should return true for a move to a space with different color piece' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      white_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      expect(white_rook.valid_move?(6, 0)).to eq true
    end

    it 'should return false for an obstructed move to an empty spot' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      expect(white_rook.valid_move?(2, 0)).to eq false
    end
  end

  describe 'obstructed_spots' do
    it 'returns pieces of threatening piece\'s path to checked king' do
      game = FactoryGirl.create(:game)
      game.pieces.destroy_all
      black_rook = FactoryGirl.create(:rook, game: game, current_row_index: 0, current_column_index: 0, captured: false, color: 'black')
      FactoryGirl.create(:king, game: game, current_row_index: 0, current_column_index: 4, captured: false, color: 'white')
      expect(black_rook.obstructed_spots(0, 4)).to eq [[0, 1], [0, 2], [0, 3]]
    end
  end
end
