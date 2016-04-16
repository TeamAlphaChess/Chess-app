# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Pawn, type: :model do
  describe 'valid_move?' do
    it 'should return false if trying to move horizontal' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      white_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      expect(white_pawn.valid_move?(3, 2)).to eq false
    end

    it 'should return false if trying to move backwards' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      white_pawn.update_attributes(current_row_index: 3, current_column_index: 0)
      expect(white_pawn.valid_move?(2, 0)).to eq false
    end

    it 'should return false if trying to move diagonal with no capture' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      expect(white_pawn.valid_move?(2, 1)).to eq false
    end

    it 'should return false if it tries to move forward and its blocked' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # select black piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      # Move black pawn to be in the way
      black_pawn.update_attributes(current_row_index: 2, current_column_index: 0)
      expect(white_pawn.valid_move?(2, 0)).to eq false
    end

    it 'should return false if trying to move two spaces on anymove but the first' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      white_pawn.update_attributes(current_row_index: 2, current_column_index: 0)
      expect(white_pawn.valid_move?(4, 0)).to eq false
    end

    it 'should return false if it tries to move two spaces on the opposite row' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      black_rook = game.pieces.find_by_current_row_index_and_current_column_index(7, 0)
      black_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      black_rook.update_attributes(current_row_index: nil, current_column_index: nil)
      white_pawn.update_attributes(current_row_index: 6, current_column_index: 0)
      expect(white_pawn.valid_move?(8, 0)).to eq false
    end

    it 'should return true if the first move tries to move two spaces forward(white)' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      expect(white_pawn.valid_move?(3, 0)).to eq true
    end

    it 'should return true if the first move tries to move two spaces forward(black)' do
      game = FactoryGirl.create(:game)
      # Select pawn
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      expect(black_pawn.valid_move?(4, 0)).to eq true
    end

    it 'should return true if it can move one space forward to an empty spot' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      expect(white_pawn.valid_move?(2, 0)).to eq true
    end

    it 'should return true for this capture' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # select black piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      # Move black pawn to be in the way
      black_pawn.update_attributes(current_row_index: 2, current_column_index: 1)
      expect(white_pawn.valid_move?(2, 1)).to eq true
    end
  end

  describe 'en_passant?' do
    it 'should return true if en_passant? passes for (black color making the move)' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # select black piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      # Move black pawn to be in the way
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      white_pawn.update_attributes(current_row_index: 3, current_column_index: 0, move_count: 1)
      expect(black_pawn.en_passant?(2, 0)).to eq true
    end

    it 'should return false if white_pawn takes 2 (1 square) moves forward instead of one (2 square) (black color making the move)' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # select black piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      # Move black pawn to be in the way
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      white_pawn.move_to!(2, 0)
      white_pawn.move_to!(3, 0)
      expect(black_pawn.en_passant?(2, 0)).to eq false
    end

    it 'should return true if en_passant? passes for (white color making the move)' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # select black piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      # Move black pawn to be in the way
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 0, move_count: 1)
      white_pawn.update_attributes(current_row_index: 4, current_column_index: 1)
      expect(white_pawn.en_passant?(5, 0)).to eq true
    end

    it 'should return false if move is not an en_passant move' do
      game = FactoryGirl.create(:game)
      # select black piece
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      # Move black pawn to be in the way
      expect(black_pawn.en_passant?(5, 0)).to eq false
    end
  end
end
