require 'rails_helper'
RSpec.describe Rook, type: :model do
  describe 'valid_move?' do
    it 'should allow a horizontal-right move' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 5)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 5)
      # Update white rook's position to be in same row and left of black pawn
      white_rook.update_attributes(current_row_index:  3, current_column_index: 0)
      # Expect white king's move to pawn's space to be valid
      expect(white_rook.valid_move?(3, 5)).to eq true
    end

    it 'should allow a horizontal-left move' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 7)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      # Update white rook's position to be in same row and right of black pawn
      white_rook.update_attributes(current_row_index: 3, current_column_index: 7)
      # Expect white's king's move to pawn's space to be valid
      expect(white_rook.valid_move?(3, 1)).to eq true
    end

    it 'should allow a vertical-up move' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 2, current_row_index: 3)
      # Update white rook's position to be in same column and below black pawn
      black_pawn.update_attributes(current_row_index: 4, current_row_index: 3)
      # Expect white's king's move to pawn's space to be valid
      expect(white_rook.valid_move?(2, 3)).to eq true
    end

    it 'should allow a vertical-down move' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 5, current_row_index: 0)
      # Update white rook's position to be in same column and below black pawn
      black_pawn.update_attributes(current_row_index: 3, current_row_index: 0)
      # Expect white's king's move to pawn's space to be valid
      expect(white_rook.valid_move?(5, 0)).to eq true
    end

    it 'should NOT allow a move to a space with same color piece' do
      game = FactoryGirl.create(:game)
      # Select white rook from the board
      white_rook = game.pieces.find_by_current_row_index_and_current_column_index(0, 0)
      # Select white pawn from the board
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      # Expect white king's move to white pawn's space to be invalid
      expect(white_rook.valid_move?(1, 0)).to eq false
    end

    it 'should NOT allow a move to a space if path is obstructed' do
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