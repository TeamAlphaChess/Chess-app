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

    it 'should return true if the first move to move tries to move two spaces forward' do
      game = FactoryGirl.create(:game)
      # Select pawn
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      expect(white_pawn.valid_move?(3, 0)).to eq true
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
      expect(white_pawn.valid_move?(2,1)).to eq true
    end
  end
end
