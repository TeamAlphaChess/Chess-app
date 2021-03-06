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
    it 'should return true for black pawn en_passant?' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      white_pawn.update_attributes(current_row_index: 3, current_column_index: 0, move_count: 1)
      expect(black_pawn.en_passant?(2, 0)).to eq true
    end

    it 'should return false for black pawn en_passant? if white_pawn takes 2 (1 spot) moves forward instead of one (2 spot) move' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      white_pawn.move_to!(2, 0)
      white_pawn.move_to!(3, 0)
      expect(black_pawn.en_passant?(2, 0)).to eq false
    end

    it 'should return true for white pawn en_passant?' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      white_pawn.update_attributes(current_row_index: 4, current_column_index: 0)
      black_pawn.move_to!(4, 1)
      expect(white_pawn.en_passant?(5, 1)).to eq true
    end

    it 'should return false if move is not an en_passant move' do
      game = FactoryGirl.create(:game)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      expect(black_pawn.en_passant?(5, 0)).to eq false
    end

    it 'should return false if the last move in the game was not an opposing pawn piece moving forward 2 spots' do
      game = FactoryGirl.create(:game)
      white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 0)
      other_white_pawn = game.pieces.find_by_current_row_index_and_current_column_index(1, 1)
      black_pawn = game.pieces.find_by_current_row_index_and_current_column_index(6, 1)
      black_pawn.update_attributes(current_row_index: 3, current_column_index: 1)
      white_pawn.move_to!(3, 0)
      other_white_pawn.move_to!(2, 1)
      expect(black_pawn.en_passant?(2, 0)).to eq false
    end
  end

  describe 'white_pawn_in_starting_row?' do
    it 'should return true if the pawn is in the original start position' do
      pawn = FactoryGirl.create(:pawn, color: 'white', current_row_index: 1, current_column_index: 3)
      expect(pawn.white_pawn_in_starting_row?).to eq true
    end

    it 'should return false if the pawn is not in the original start position' do
      pawn = FactoryGirl.create(:pawn, color: 'white', current_row_index: 3, current_column_index: 3)
      expect(pawn.white_pawn_in_starting_row?).to eq false
    end
  end

  describe 'black_pawn_in_starting_row?' do
    it 'should return true if the pawn is in the original start position' do
      pawn = FactoryGirl.create(:pawn, color: 'black', current_row_index: 6, current_column_index: 3)
      expect(pawn.black_pawn_in_starting_row?).to eq true
    end

    it 'should return false if the pawn is not in the original start position' do
      pawn = FactoryGirl.create(:pawn, color: 'black', current_row_index: 4, current_column_index: 3)
      expect(pawn.black_pawn_in_starting_row?).to eq false
    end
  end
end
