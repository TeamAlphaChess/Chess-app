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

    it 'should allow a vertical-down move' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      white_pawn.update_attributes(current_row_index: nil, current_column_index: nil)
      expect(white_rook.valid_move?(1, 0)).to eq true
    end

    it 'should return false for a move to a space with same color piece' do
      game = FactoryGirl.create(:game)
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      expect(white_rook.valid_move?(1, 0)).to eq false
    end

    it 'should return true for a move to a space with different color piece' do
      game = FactoryGirl.create(:game)
      # white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # expect(white_rook.valid_move?(1, 0)).to eq false
    end




    it 'should return false for a move to a space if path is obstructed' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # Select black pawn from the board 
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 0)
      # find/select white pawn that obstructs??

      # Expect white king's move to black pawn's space to be invalid because white pawn obstructs
      expect(white_rook.valid_move?(6, 0)).to eq false

    end

    it 'should NOT allow an unobstructed move if piece is same color' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # Select white pawn from the board
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # Update white pawn's position
      white_pawn.update_attributes(current_row_index: 5, current_column_index: 0)
      # Expect white king's move to white pawn's space to be invalid
      expect(white_rook.valid_move?(5, 0)).to eq false

    end

  end
end