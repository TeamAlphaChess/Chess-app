# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Knight, type: :model do
  describe 'valid_move?' do
    it 'should return true for valid_move if theres an empty destination spot' do
      game = FactoryGirl.create(:game)
      # Select white knight from the board
      white_knight = game.pieces.find_by_current_row_index_and_current_column_index(0, 1)
      # Should return true as if destination spot is empty
      expect(white_knight.valid_move?(2, 2)).to eq true
    end

    it 'should return false for valid_move if theres a piece with same color in the destination spot' do
      game = FactoryGirl.create(:game)
      # Select white knight from the board
      white_knight = game.pieces.find_by_current_row_index_and_current_column_index(0, 1)
      # Should return false as there is an existing same color piece in the destination square
      expect(white_knight.valid_move?(1, 3)).to eq false
    end

    it 'should return false if piece move is invalid' do
      game = FactoryGirl.create(:game)
      # Select white knight from the board
      white_knight = game.pieces.find_by_current_row_index_and_current_column_index(0, 1)
      # Should return false as a knight cannot move two squares forward
      expect(white_knight.valid_move?(2, 1)).to eq false
    end

    it 'should return true for valid_move if theres a piece with different color' do
      game = FactoryGirl.create(:game)
      # Select white knight from the board
      white_knight = game.pieces.find_by_current_row_index_and_current_column_index(0, 1)
      # Select white pawn from the board
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 3)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Remove white_pawn from board
      white_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      # Move black_pawn into (1, 3) spot
      black_pawn.update_attributes(current_row_index: 1, current_column_index: 3)
      # Should return true as it is a valid move and there is a piece with different color in destination spot
      expect(white_knight.valid_move?(1, 3)).to eq true
    end
  end
end
