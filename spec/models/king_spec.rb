# frozen_string_literal: true
require 'rails_helper'
RSpec.describe King, type: :model do
  describe 'valid_move?' do
    it 'should allow a vertical-up move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 4)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 4)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 5, current_column_index: 4)
      expect(white_king.valid_move?(4, 4)).to eq true
    end

    it 'should allow a vertical-down move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 5, current_column_index: 4)
      expect(white_king.valid_move?(6, 4)).to eq true
    end

    it 'should allow a horizonal-left move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 3)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 4, current_column_index: 4)
      expect(white_king.valid_move?(4, 3)).to eq true
    end

    it 'should allow a horizonal-right move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 5)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 5)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 4, current_column_index: 4)
      expect(white_king.valid_move?(4, 5)).to eq true
    end

    it 'should allow a diagonal-up-right move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 5)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 5)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 5, current_column_index: 4)
      expect(white_king.valid_move?(4, 5)).to eq true
    end

    it 'should allow a diagonal-up-left move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 3)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 5, current_column_index: 4)
      expect(white_king.valid_move?(4, 3)).to eq true
    end

    it 'should allow a diagonal-down-right move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 5)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 3, current_column_index: 4)
      expect(white_king.valid_move?(4, 5)).to eq true
    end

    it 'should allow a diagonal-down-left move' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Select black pawn from the board
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 3)
      # Update black pawn position
      black_pawn.update_attributes(current_row_index: 4, current_column_index: 3)
      # Update king's position to be in front of black pawn
      white_king.update_attributes(current_row_index: 3, current_column_index: 4)
      expect(white_king.valid_move?(4, 3)).to eq true
    end

    it 'should not allow a move to a space if piece is same color' do
      game = FactoryGirl.create(:game)
      # Select white king from the board
      white_king = game.pieces.find_by_current_row_index_and_current_column_index(0, 4)
      # Update white king attributes to be on white pawn's occupied location
      expect(white_king.valid_move?(1, 4)).to eq false
    end
  end
end
